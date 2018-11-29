//
//  ZZ10x10Form.m
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import "ZZ10x10Form.h"
#import "ZZBrick.h"

@interface ZZ10x10Form ()

@property (nonatomic, strong) NSMutableSet<ZZBrick *> *realSet;
@property (nonatomic, strong) NSMutableArray<ZZBrick *> *tempSet;
@property (nonatomic, strong) NSMutableArray<ZZBrick *> *nextSet;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isGameOver;

@end

static dispatch_semaphore_t lock;

@implementation ZZ10x10Form

 - (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 0.5;
        for (NSInteger x = 0; x < FormW; x ++) {
            for (NSInteger y = 0; y < FormH; y ++) {
                UIView *grid = [UIView new];
                grid.backgroundColor = [UIColor lightGrayColor];
                grid.layer.borderWidth = 0.5;
                grid.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
                grid.frame = CGRectMake(realInt(x), realInt(y), realInt(1), realInt(1));
                [self addSubview:grid];
            }
        }
        lock = dispatch_semaphore_create(1);
        self.realSet = [NSMutableSet set];
        self.tempSet = [NSMutableArray new];
        self.nextSet = [NSMutableArray new];
        if (!_timer) {
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 0.2 * NSEC_PER_SEC, 0);
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
                    dispatch_semaphore_signal(lock);
                } else {
                    [self.realSet addObjectsFromArray:self.tempSet];
                    [self.tempSet removeAllObjects];
                    [self actualizeBricks];
                    [self createBricks];
                    if (![self canUpdateBricks:ZZBrickDirectionDown]) {
                        dispatch_suspend(self.timer);
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
    return self;
}

// 预生成新方块
- (void)preCreateBricks
{
    ZZBrickType type = (ZZBrickType)(arc4random()%19);
    ZZGrid *grid = [[ZZGrid alloc] initWithType:type];
    NSInteger w = arc4random()%(FormW-grid.w);
    NSMutableArray *tempBricks = [NSMutableArray new];
    [grid.brickGrids enumerateObjectsUsingBlock:^(ZZPoint * _Nonnull point, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect frame = CGRectMake(realInt(point.x), realInt(point.y+4), realInt(1), realInt(1));
        ZZBrick *brick = [[ZZBrick alloc] initWithFrame:frame point:point backgroundColor:grid.brickColor borderColor:grid.borderColor];
        [tempBricks addObject:brick];
        
        point.x += w;
        frame = CGRectMake(realInt(point.x), realInt(point.y), realInt(1), realInt(1));
        brick = [[ZZBrick alloc] initWithFrame:frame point:point backgroundColor:grid.brickColor borderColor:grid.borderColor];
        brick.grid = grid;
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

// 方块可移动或下落
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

// 移动方块或下落
- (void)updateBrick:(ZZBrick *)brick direction:(ZZBrickDirection)direction interval:(NSInteger)interval
{
    [UIView animateWithDuration:0.0 animations:^{
        if (direction == ZZBrickDirectionLeft) {
            brick.left -= realInt(interval);
        } else if (direction == ZZBrickDirectionRight) {
            brick.left += realInt(interval);
        } else {
            brick.top += realInt(interval);
        }
    } completion:^(BOOL finished) {
        if (direction == ZZBrickDirectionLeft) {
            brick.point.x -= interval;
        } else if (direction == ZZBrickDirectionRight) {
            brick.point.x += interval;
        } else {
            brick.point.y += interval;
        }
    }];
}

// 翻转方块
- (void)reversalBricksWithGrid:(ZZGrid *)oldGrid x:(NSInteger)x y:(NSInteger)y h:(NSInteger)h
{
    ZZGrid *grid = [[ZZGrid alloc] initWithType:oldGrid.reversalBrickType];
    grid.brickColor = oldGrid.brickColor;
    NSInteger left = grid.w>oldGrid.w?((grid.w+x)>FormW?(FormW-grid.w):x):x;
    NSInteger top = (h+grid.h+1);
    
    for (ZZPoint *point in grid.brickGrids) {
        point.x += left;
        point.y += top;
        CGRect frame = CGRectMake(realInt(point.x), realInt(point.y), realInt(1), realInt(1));
        if (point.y > FormH) {
            return;
        }
        for (ZZBrick *brick in self.realSet) {
            if (CGRectIntersectsRect(frame, brick.frame)) {
                return;
            }
        }
    }
    NSMutableArray<ZZBrick *> *tempSet = [NSMutableArray new];
    for (ZZPoint *point in grid.brickGrids) {
        CGRect frame = CGRectMake(realInt(point.x), realInt(point.y), realInt(1), realInt(1));
        ZZBrick *brick = [[ZZBrick alloc] initWithFrame:frame point:point backgroundColor:grid.brickColor borderColor:grid.borderColor];
        brick.grid = grid;
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

// 消层
- (void)actualizeBricks
{
    NSMutableArray *totalBricks = [NSMutableArray new];
    for (NSInteger index = FormH-1; index >= 0; index --) {
        NSMutableSet *floorBricks = [NSMutableSet set];
        [self.realSet enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, BOOL * _Nonnull stop) {
            if (index == brick.point.y) {
                [floorBricks addObject:brick];
            }
        }];
        [totalBricks addObject:floorBricks];
    }
    NSInteger floorNum = 0;
    for (NSInteger index = 0; index < FormH; index ++) {
        NSMutableSet *floorBricks = totalBricks[index];
        if (floorBricks.count == FormW) {
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

- (void)leftClick
{
    if (!self.isPlaying) return;
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
    if (!self.isPlaying) return;
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
    if (!self.isPlaying) return;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    if ([self canUpdateBricks:ZZBrickDirectionDown]) {
        [self.tempSet enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, NSUInteger idx, BOOL * _Nonnull stop) {
            [self updateBrick:brick direction:ZZBrickDirectionDown interval:1];
        }];
    }
    dispatch_semaphore_signal(lock);
}

- (void)reversalClick
{
    if (!self.isPlaying) return;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    ZZGrid *grid = self.tempSet.firstObject.grid;
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
    NSInteger h = y-grid.h;
    [self reversalBricksWithGrid:grid x:x y:y h:h];
    dispatch_semaphore_signal(lock);
}

- (void)restartClick
{
    dispatch_suspend(self.timer);
    self.isGameOver = YES;
    [self playClick:YES];
    self.isGameOver = NO;
    if (self.restartBlock) {
        self.restartBlock();
    }
    if (self.scoreBlock) {
        self.scoreBlock(0);
    }
}

- (void)playClick:(BOOL)isPlaying
{
    self.isPlaying = isPlaying;
    if (isPlaying) {
        if (self.isGameOver) {
            [self.tempSet makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.realSet makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.realSet removeAllObjects];
            [self.tempSet removeAllObjects];
        } else {
            dispatch_resume(self.timer);
        }
    } else {
        dispatch_suspend(self.timer);
    }
}

@end
