//
//  ViewController.m
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import "ViewController.h"
#import "ZZTetrisBoard.h"

@interface ViewController ()

@property (nonatomic, strong) ZZTetrisBoard *board;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#DBA734"];

    static NSInteger totalScore = 0;
    NSInteger w = realInt(BoardWidth);
    NSInteger h = realInt(BoardHeight);
    CGFloat xy = (SCREEN_WIDTH-w)/2.0;
    
    UIImageView *playLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zzPlayLogo"]];
    playLogo.frame = CGRectMake(20, 30, xy, xy/2.0);
    playLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:playLogo];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xy, 20, w, (xy-20)/2.0)];
    titleLabel.text = @"ZZTETRIS";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor randomColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:(xy-20)/3.0];
    [self.view addSubview:titleLabel];
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(xy, titleLabel.bottom, w/2.0, xy-titleLabel.bottom)];
    scoreLabel.text = @"score:";
    scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.textColor = [UIColor randomColor];
    scoreLabel.font = [UIFont boldSystemFontOfSize:(xy-20)/4.0];
    [self.view addSubview:scoreLabel];

    UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(xy+w/2.0, titleLabel.bottom, w/2.0, xy-titleLabel.bottom)];
    score.text = [NSString stringWithFormat:@"%zd", totalScore];
    score.textAlignment = NSTextAlignmentCenter;
    score.textColor = [UIColor randomColor];
    score.font = [UIFont boldSystemFontOfSize:(xy-20)/4.0];
    [self.view addSubview:score];

    self.board = [[ZZTetrisBoard alloc] initWithFrame:CGRectMake(xy, xy, w, h)];
    [self.view addSubview:self.board];
    
    CGFloat btnTop = self.board.bottom+xy/2.0;
    CGFloat btnInterval = w/8.0;
    CGFloat btnWidth = btnInterval*2;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(xy, btnTop, btnWidth, btnWidth);
    [left setImage:[UIImage imageNamed:@"zzleft"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(xy+2*btnWidth, btnTop, btnWidth, btnWidth);
    [right setImage:[UIImage imageNamed:@"zzright"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
    play.frame = CGRectMake(xy+btnWidth, btnTop, btnWidth, btnWidth);
    [play setImage:[UIImage imageNamed:@"zzplay"] forState:UIControlStateNormal];
    [play setImage:[UIImage imageNamed:@"zzpause"] forState:UIControlStateSelected];
    [play addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:play];
    
    UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
    down.frame = CGRectMake(xy+btnWidth, btnTop+btnWidth, btnWidth, btnWidth);
    [down setImage:[UIImage imageNamed:@"zzdown"] forState:UIControlStateNormal];
    [down addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:down];

    UIButton *restart = [UIButton buttonWithType:UIButtonTypeCustom];
    restart.frame = CGRectMake(self.board.right+(xy-realInt(3))/2.0, self.board.top-realInt(3), realInt(3), realInt(3));
    [restart setImage:[UIImage imageNamed:@"zzrestart"] forState:UIControlStateNormal];
    [restart addTarget:self action:@selector(restartClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restart];

    UILabel *restartLabel = [[UILabel alloc] initWithFrame:CGRectMake(restart.left, restart.bottom, restart.width, 30)];
    restartLabel.text = @"Restart";
    restartLabel.textAlignment = NSTextAlignmentCenter;
    restartLabel.textColor = [UIColor randomColor];
    restartLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:restartLabel];

    UILabel *rapidLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.board.right+(xy-realInt(4))/2.0, self.board.centerY-realInt(4), realInt(4), realInt(2))];
    rapidLabel.text = @"Level 3";
    rapidLabel.textAlignment = NSTextAlignmentCenter;
    rapidLabel.textColor = [UIColor randomColor];
    rapidLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:rapidLabel];

    UIButton *rapidPlus = [UIButton buttonWithType:UIButtonTypeCustom];
    rapidPlus.frame = CGRectMake(rapidLabel.left, rapidLabel.bottom, rapidLabel.width/2.0, rapidLabel.width/2.0);
    rapidPlus.layer.borderWidth = 0.5;
    rapidPlus.layer.borderColor = [UIColor redColor].CGColor;
    rapidPlus.backgroundColor = [UIColor lightGrayColor];
    [rapidPlus setTitle:@"+" forState:UIControlStateNormal];
    [rapidPlus addTarget:self action:@selector(rapidPlusClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rapidPlus];
    
    UIButton *rapidMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    rapidMinus.frame = CGRectMake(rapidLabel.centerX, rapidLabel.bottom, rapidLabel.width/2.0, rapidLabel.width/2.0);
    rapidMinus.layer.borderWidth = 0.5;
    rapidMinus.layer.borderColor = [UIColor redColor].CGColor;
    rapidMinus.backgroundColor = [UIColor lightGrayColor];
    [rapidMinus setTitle:@"-" forState:UIControlStateNormal];
    [rapidMinus addTarget:self action:@selector(rapidMinusClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rapidMinus];

    UIButton *reversal = [UIButton buttonWithType:UIButtonTypeCustom];
    reversal.frame = CGRectMake(xy+3*btnWidth, btnTop, btnWidth*2, btnWidth*2);
    [reversal setImage:[UIImage imageNamed:@"zzreversal"] forState:UIControlStateNormal];
    [reversal addTarget:self action:@selector(reversalClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reversal];
    
    UIView *nextBricksBg = [[UIView alloc] initWithFrame:CGRectMake(self.board.right+(xy-realInt(4))/2.0, self.board.bottom-realInt(4), realInt(4), realInt(4))];
    nextBricksBg.layer.borderColor = [UIColor redColor].CGColor;
    nextBricksBg.layer.borderWidth = 0.5;
    [self.view addSubview:nextBricksBg];
    
    for (NSInteger x = 0; x < 4; x ++) {
        for (NSInteger y = 0; y < 4; y ++) {
            UIView *grid = [UIView new];
            grid.backgroundColor = [UIColor lightGrayColor];
            grid.layer.borderWidth = 0.5;
            grid.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
            grid.frame = CGRectMake(realInt(x), realInt(y), realInt(1), realInt(1));
            [nextBricksBg addSubview:grid];
        }
    }

    UIView *nextBricks = [[UIView alloc] initWithFrame:nextBricksBg.bounds];
    [nextBricksBg addSubview:nextBricks];

    UILabel *next = [[UILabel alloc] initWithFrame:CGRectMake(nextBricksBg.left, nextBricksBg.top-30, nextBricksBg.width, 30)];
    next.text = @"Next";
    next.textAlignment = NSTextAlignmentCenter;
    next.textColor = [UIColor randomColor];
    next.font = [UIFont boldSystemFontOfSize:20.0];
    [self.view addSubview:next];
    
    self.board.rapidPlusBlock = ^(NSInteger rapidLevel) {
        [UIView animateWithDuration:0.01 animations:^{
            rapidLabel.text = [NSString stringWithFormat:@"Level %zd", rapidLevel];
        }];
    };
    self.board.rapidMinusBlock = ^(NSInteger rapidLevel) {
        [UIView animateWithDuration:0.01 animations:^{
            rapidLabel.text = [NSString stringWithFormat:@"Level %zd", rapidLevel];
        }];
    };
    self.board.scoreBlock = ^(NSInteger scoreNum) {
        totalScore += scoreNum;
        [UIView animateWithDuration:0.01 animations:^{
            score.text = [NSString stringWithFormat:@"%zd", totalScore];
        }];
    };
    self.board.nextBricksBlock = ^(NSArray<ZZBrick *> *bricks) {
        [UIView animateWithDuration:0.01 animations:^{
            [nextBricks.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [bricks enumerateObjectsUsingBlock:^(ZZBrick * _Nonnull brick, NSUInteger idx, BOOL * _Nonnull stop) {
                [nextBricks addSubview:brick];
            }];
        }];
    };
    self.board.gameOverBlock = ^{
        play.selected = NO;
        play.userInteractionEnabled = NO;
    };
    self.board.restartBlock = ^{
        play.selected = NO;
        play.userInteractionEnabled = YES;
        [nextBricks.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    };
}

#pragma mark - Clicks

- (void)rapidPlusClick
{
    [self.board rapidPlusClick];
}

- (void)rapidMinusClick
{
    [self.board rapidMinusClick];
}

- (void)leftClick
{
    [self.board leftClick];
}

- (void)rightClick
{
    [self.board rightClick];
}

- (void)downClick
{
    [self.board downClick];
}

- (void)reversalClick
{
    [self.board reversalClick];
}

- (void)restartClick
{
    [self.board restartClick];
}

- (void)playClick:(UIButton *)button
{
    if (button.isSelected) {
        button.selected = NO;
    } else {
        button.selected = YES;
    }
    [self.board playClick:button.selected];
}

@end
