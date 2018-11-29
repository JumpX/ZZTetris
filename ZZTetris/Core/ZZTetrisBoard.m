//
//  ZZTetrisBoard.m
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/29.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import "ZZTetrisBoard.h"

@interface ZZTetrisBoard ()

@property (nonatomic, strong) NSMutableSet<ZZBrick *> *realSet;
@property (nonatomic, strong) NSMutableArray<ZZBrick *> *tempSet;
@property (nonatomic, strong) NSMutableArray<ZZBrick *> *nextSet;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isGameOver;

@end

static dispatch_semaphore_t lock;
static NSInteger timerSemaphore;
static NSInteger rapidDown;
static NSInteger rapidLevel;

@implementation ZZTetrisBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 0.5;
        for (NSInteger x = 0; x < BoardWidth; x ++) {
            for (NSInteger y = 0; y < BoardHeight; y ++) {
                UIView *grid = [UIView new];
                grid.backgroundColor = [UIColor lightGrayColor];
                grid.layer.borderWidth = 0.5;
                grid.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
                grid.frame = CGRectMake(realInt(x), realInt(y), realInt(1), realInt(1));
                [self addSubview:grid];
            }
        }
        lock = dispatch_semaphore_create(1);
        timerSemaphore = 1;
        rapidDown = 0;
        rapidLevel = 3;
        self.realSet = [NSMutableSet set];
        self.tempSet = [NSMutableArray new];
        self.nextSet = [NSMutableArray new];
        [self createTimer];
    }
    return self;
}

#pragma mark - Timer

- (void)createTimer
{
    if (!_timer) {
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 2.0/(rapidLevel*rapidLevel) * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            if (self.nextSet.count == 0) {
                [self preCreateBricks];
            }
            if (self.tempSet.count == 0) {
                [self createBricks];
            } else if ([self canUpdateBricks:ZZBrickDirectionDown]) {
                dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
                [self.tempSet enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self updateBrick:brick direction:ZZBrickDirectionDown interval:1];
                }];
                for (NSInteger rapid = 0; rapid < rapidDown; rapid ++) {
                    if ([self canUpdateBricks:ZZBrickDirectionDown]) {
                        [self.tempSet enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, NSUInteger idx, BOOL * _Nonnull stop) {
                            [self updateBrick:brick direction:ZZBrickDirectionDown interval:1];
                        }];
                    } else break;
                }
                rapidDown = 0;
                dispatch_semaphore_signal(lock);
            } else {
                [self.realSet addObjectsFromArray:self.tempSet];
                [self.tempSet removeAllObjects];
                [self actualizeBricks];
                [self createBricks];
                if (![self canUpdateBricks:ZZBrickDirectionDown]) {
                    [self dispatchSuspendTimer];
                    NSLog(@"game over...");
                    self.isGameOver = YES;
                    if (self.gameOverBlock) {
                        self.gameOverBlock();
                    }
                }
            }
        });
    }
}

- (void)dispatchResumeTimer
{
    if (timerSemaphore == 1) {
        dispatch_resume(self.timer);
        timerSemaphore = 0;
    }
}

- (void)dispatchSuspendTimer
{
    if (timerSemaphore == 0) {
        dispatch_suspend(self.timer);
        timerSemaphore = 1;
    }
}

#pragma mark - Bricks

// 预生成新方块
- (void)preCreateBricks
{
    ZZBrickType type = (ZZBrickType)(arc4random()%19);
    ZZBrickConfig *config = [[ZZBrickConfig alloc] initWithType:type];
    NSInteger w = arc4random()%(BoardWidth-config.w);
    NSMutableArray *tempBricks = [NSMutableArray new];
    [config.brickPoints enumerateObjectsUsingBlock:^(ZZPoint * _Nonnull point, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect frame = CGRectMake(realInt(point.x), realInt(point.y+4), realInt(1), realInt(1));
        ZZBrick *brick = [[ZZBrick alloc] initWithFrame:frame point:point backgroundColor:config.brickColor borderColor:config.borderColor];
        [tempBricks addObject:brick];
        
        point.x += w;
        frame = CGRectMake(realInt(point.x), realInt(point.y), realInt(1), realInt(1));
        brick = [[ZZBrick alloc] initWithFrame:frame point:point backgroundColor:config.brickColor borderColor:config.borderColor];
        brick.config = config;
        [self.nextSet addObject:brick];
    }];
    if (self.tempSet.count > 0) {
        if (self.nextBricksBlock) {
            self.nextBricksBlock(tempBricks);
        }
    }
}

// 生成新方块
- (void)createBricks
{
    [self.tempSet addObjectsFromArray:self.nextSet];
    [self.nextSet removeAllObjects];
    [self.tempSet enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:brick];
    }];
}

// 方块可移动
- (BOOL)canUpdateBricks:(ZZBrickDirection)direction
{
    for (ZZBrick *tempBrick in self.tempSet) {
        if (direction == ZZBrickDirectionLeft) {
            if ((NSInteger)(tempBrick.left-realInt(1)) < 0) {
                return NO;
            }
            for (ZZBrick *realBrick in self.realSet) {
                if (tempBrick.leftPoint.x == realBrick.point.x &&
                    tempBrick.leftPoint.y == realBrick.point.y) {
                    return NO;
                }
            }
        } else if (direction == ZZBrickDirectionRight) {
            if ((NSInteger)(tempBrick.right+realInt(1)) > (NSInteger)(self.width)) {
                return NO;
            }
            for (ZZBrick *realBrick in self.realSet) {
                if (tempBrick.rightPoint.x == realBrick.point.x &&
                    tempBrick.rightPoint.y == realBrick.point.y) {
                    return NO;
                }
            }
        } else {
            if ((NSInteger)(tempBrick.bottom+realInt(1)) > (NSInteger)(self.height)) {
                return NO;
            }
            for (ZZBrick *realBrick in self.realSet) {
                if (tempBrick.downPoint.x == realBrick.point.x &&
                    tempBrick.downPoint.y == realBrick.point.y) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

// 移动方块
- (void)updateBrick:(ZZBrick *)brick direction:(ZZBrickDirection)direction interval:(NSInteger)interval
{
    [UIView animateWithDuration:0.0 animations:^{
        if (direction == ZZBrickDirectionLeft) {
            brick.left -= realInt(interval);
            brick.point.x -= interval;

        } else if (direction == ZZBrickDirectionRight) {
            brick.left += realInt(interval);
            brick.point.x += interval;

        } else {
            brick.top += realInt(interval);
            brick.point.y += interval;
        }
    }];
}

// 翻转方块
- (void)reversalBricksWithConfig:(ZZBrickConfig *)oldConfig x:(NSInteger)x y:(NSInteger)y h:(NSInteger)h
{
    ZZBrickConfig *config = [[ZZBrickConfig alloc] initWithType:oldConfig.reversalBrickType];
    config.brickColor = oldConfig.brickColor;
    NSInteger left = config.w>oldConfig.w?((config.w+x)>BoardWidth?(BoardWidth-config.w):x):x;
    NSInteger top = (h+config.h+1);
    
    for (ZZPoint *point in config.brickPoints) {
        point.x += left;
        point.y += top;
        CGRect frame = CGRectMake(realInt(point.x), realInt(point.y), realInt(1), realInt(1));
        if (point.y > BoardHeight-1) {
            return;
        }
        for (ZZBrick *brick in self.realSet) {
            if (CGRectIntersectsRect(frame, brick.frame)) {
                return;
            }
        }
    }
    NSMutableArray<ZZBrick *> *tempSet = [NSMutableArray new];
    for (ZZPoint *point in config.brickPoints) {
        CGRect frame = CGRectMake(realInt(point.x), realInt(point.y), realInt(1), realInt(1));
        ZZBrick *brick = [[ZZBrick alloc] initWithFrame:frame point:point backgroundColor:config.brickColor borderColor:config.borderColor];
        brick.config = config;
        [tempSet addObject:brick];
    }
    
    for (NSInteger index = 0; index < tempSet.count; index ++) {
        ZZBrick *newBrick = tempSet[index];
        ZZBrick *oldBrick = self.tempSet[index];
        [UIView animateWithDuration:0.01 animations:^{
            [oldBrick removeFromSuperview];
            [self addSubview:newBrick];
        }];
    }
    [self.tempSet removeAllObjects];
    [self.tempSet addObjectsFromArray:tempSet];
    [tempSet removeAllObjects];
}

// 方块消层
- (void)actualizeBricks
{
    NSMutableArray *totalBricks = [NSMutableArray new];
    for (NSInteger index = BoardHeight-1; index >= 0; index --) {
        NSMutableSet *floorBricks = [NSMutableSet set];
        [self.realSet enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, BOOL * _Nonnull stop) {
            if (index == brick.point.y) {
                [floorBricks addObject:brick];
            }
        }];
        [totalBricks addObject:floorBricks];
    }
    NSInteger floorNum = 0;
    for (NSInteger index = 0; index < BoardHeight; index ++) {
        NSMutableSet *floorBricks = totalBricks[index];
        if (floorBricks.count == BoardWidth) {
            [floorBricks enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, BOOL * _Nonnull stop) {
                [UIView animateWithDuration:0.0 animations:^{
                    [brick removeFromSuperview];
                } completion:^(BOOL finished) {
                    [self.realSet removeObject:brick];
                }];
            }];
            floorNum += 1;
        } else {
            [floorBricks enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, BOOL * _Nonnull stop) {
                [self updateBrick:brick direction:ZZBrickDirectionDown interval:floorNum];
            }];
        }
    }
    if (floorNum > 0) {
        if (self.scoreBlock) {
            self.scoreBlock(floorNum*100);
        }
    }
}

#pragma mark - Clicks

- (void)rapidPlusClick
{
    if (rapidLevel < 5) {
        rapidLevel ++;
    }
    if (self.rapidPlusBlock) {
        self.rapidPlusBlock(rapidLevel);
    }
}

- (void)rapidMinusClick
{
    if (rapidLevel > 1) {
        rapidLevel --;
    }
    if (self.rapidMinusBlock) {
        self.rapidMinusBlock(rapidLevel);
    }
}

- (void)leftClick
{
    if (self.isGameOver || !self.isPlaying) return;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    if ([self canUpdateBricks:ZZBrickDirectionLeft]) {
        [self.tempSet enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, NSUInteger idx, BOOL * _Nonnull stop) {
            [self updateBrick:brick direction:ZZBrickDirectionLeft interval:1];
        }];
    }
    dispatch_semaphore_signal(lock);
}

- (void)rightClick
{
    if (self.isGameOver || !self.isPlaying) return;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    if ([self canUpdateBricks:ZZBrickDirectionRight]) {
        [self.tempSet enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, NSUInteger idx, BOOL * _Nonnull stop) {
            [self updateBrick:brick direction:ZZBrickDirectionRight interval:1];
        }];
    }
    dispatch_semaphore_signal(lock);
}

- (void)downClick
{
    if (self.isGameOver || !self.isPlaying) return;
    rapidDown = 5;
}

- (void)reversalClick
{
    if (self.isGameOver || !self.isPlaying) return;
    if (self.tempSet.count == 0) return;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    ZZBrickConfig *config = self.tempSet.firstObject.config;
    NSInteger y = -5;
    NSInteger x = -1;
    for (ZZBrick *brick in self.tempSet) {
        if (brick.point.y > y) {
            y = brick.point.y;
        }
        if (x < 0 || brick.point.x < x) {
            x = brick.point.x;
        }
    }
    NSInteger h = y-config.h;
    [self reversalBricksWithConfig:config x:x y:y h:h];
    dispatch_semaphore_signal(lock);
}

- (void)restartClick
{
    self.isGameOver = NO;
    [self dispatchSuspendTimer];
    [self.tempSet makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.realSet makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tempSet removeAllObjects];
    [self.realSet removeAllObjects];
    if (self.restartBlock) {
        self.restartBlock();
    }
    if (self.scoreBlock) {
        self.scoreBlock(0);
    }
}

- (void)playClick:(BOOL)isPlaying
{
    if (self.isGameOver) return;
    self.isPlaying = isPlaying;
    if (isPlaying) {
        [self dispatchResumeTimer];
    } else {
        [self dispatchSuspendTimer];
    }
}

@end
