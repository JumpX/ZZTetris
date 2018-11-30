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
    self.view.backgroundColor = [UIColor colorWithHex:@"#C7EDCC"];
    UIColor *randomColor = [UIColor randomColor];
    static NSInteger totalScore = 0;
    NSInteger w = realInt(BoardWidth);
    NSInteger h = realInt(BoardHeight);
    CGFloat x = (SCREEN_WIDTH-w)/3.0;
    CGFloat y = (SCREEN_WIDTH-w)/2.0;
    
    UIImageView *playLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zzPlayLogo"]];
    playLogo.frame = CGRectMake(20, 30, y, y/2.0);
    playLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:playLogo];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(y, 20, w, (y-20)/2.0)];
    titleLabel.text = @"ZZTETRIS";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHex:@"#416d2e"];
    titleLabel.font = [UIFont boldSystemFontOfSize:(y-20)/3.0];
    [self.view addSubview:titleLabel];
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, titleLabel.bottom, w/2.0, y-titleLabel.bottom)];
    scoreLabel.text = @"score:";
    scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.textColor = [UIColor colorWithHex:@"#cc4125"];
    scoreLabel.font = [UIFont boldSystemFontOfSize:(y-20)/4.0];
    [self.view addSubview:scoreLabel];

    UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(x+w/2.0, titleLabel.bottom, w/2.0, y-titleLabel.bottom)];
    score.text = [NSString stringWithFormat:@"%zd", totalScore];
    score.textAlignment = NSTextAlignmentCenter;
    score.textColor = randomColor;
    score.font = [UIFont boldSystemFontOfSize:(y-20)/4.0];
    [self.view addSubview:score];

    self.board = [[ZZTetrisBoard alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [self.view addSubview:self.board];
    
    CGFloat btnTop = self.board.bottom+realInt(1);
    CGFloat btnInterval = w/8.0;
    CGFloat btnWidth = btnInterval*2+realInt(2);
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(x-realInt(1), btnTop-realInt(1), btnWidth, btnWidth);
    [left setImage:[UIImage imageNamed:@"zzleft"] forState:UIControlStateNormal];
    [left setImageEdgeInsets:UIEdgeInsetsMake(realInt(1), realInt(1), realInt(1), realInt(1))];
    [left addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(x+2*btnWidth-realInt(3), btnTop-realInt(1), btnWidth, btnWidth);
    [right setImage:[UIImage imageNamed:@"zzright"] forState:UIControlStateNormal];
    [right setImageEdgeInsets:UIEdgeInsetsMake(realInt(1), realInt(1), realInt(1), realInt(1))];
    [right addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
    play.frame = CGRectMake(x+btnWidth-realInt(1), btnTop, btnWidth-realInt(2), btnWidth-realInt(2));
    [play setImage:[UIImage imageNamed:@"zzplay"] forState:UIControlStateNormal];
    [play setImage:[UIImage imageNamed:@"zzpause"] forState:UIControlStateSelected];
    [play addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:play];
    
    UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
    down.frame = CGRectMake(x+btnWidth-realInt(2), btnTop+btnWidth-realInt(1), btnWidth, btnWidth-realInt(1));
    [down setImage:[UIImage imageNamed:@"zzdown"] forState:UIControlStateNormal];
    [down setImageEdgeInsets:UIEdgeInsetsMake(0, realInt(1), realInt(1), realInt(1))];
    [down addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:down];

    UIButton *reversal = [UIButton buttonWithType:UIButtonTypeCustom];
    reversal.frame = CGRectMake(x+2*btnWidth, btnTop+realInt(3), btnWidth, btnWidth);
    [reversal setImage:[UIImage imageNamed:@"zzreversal"] forState:UIControlStateNormal];
    [reversal setImageEdgeInsets:UIEdgeInsetsMake(-realInt(1), -realInt(1), -realInt(1), -realInt(1))];
    [reversal addTarget:self action:@selector(reversalClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reversal];

    UIButton *restart = [UIButton buttonWithType:UIButtonTypeCustom];
    restart.frame = CGRectMake(self.board.right+(y-realInt(3))/2.0, self.board.top-realInt(3), realInt(3), realInt(3));
    [restart setImage:[UIImage imageNamed:@"zzrestart"] forState:UIControlStateNormal];
    [restart addTarget:self action:@selector(restartClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restart];

    UILabel *restartLabel = [[UILabel alloc] initWithFrame:CGRectMake(restart.left, restart.bottom, restart.width, 30)];
    restartLabel.text = @"Restart";
    restartLabel.textAlignment = NSTextAlignmentCenter;
    restartLabel.textColor = randomColor;
    restartLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:restartLabel];

    UILabel *rapidLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.board.right+(y-realInt(4))/2.0, self.board.centerY-realInt(4), realInt(4), realInt(2))];
    rapidLabel.text = @"Level 3";
    rapidLabel.textAlignment = NSTextAlignmentCenter;
    rapidLabel.textColor = randomColor;
    rapidLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:rapidLabel];

    UIButton *rapidPlus = [UIButton buttonWithType:UIButtonTypeCustom];
    rapidPlus.frame = CGRectMake(rapidLabel.left, rapidLabel.bottom, rapidLabel.width/2.0, rapidLabel.width/3.0);
    rapidPlus.layer.borderWidth = 1.0;
    rapidPlus.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    rapidPlus.backgroundColor = [UIColor colorWithHex:@"#cce8cf"];
    [rapidPlus.titleLabel setFont:[UIFont boldSystemFontOfSize:25.0]];
    [rapidPlus setTitle:@"+" forState:UIControlStateNormal];
    [rapidPlus setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [rapidPlus addTarget:self action:@selector(rapidPlusClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rapidPlus];
    
    UIButton *rapidMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    rapidMinus.frame = CGRectMake(rapidLabel.centerX-1.0, rapidLabel.bottom, rapidLabel.width/2.0, rapidLabel.width/3.0);
    rapidMinus.layer.borderWidth = 1.0;
    rapidMinus.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    rapidMinus.backgroundColor = [UIColor colorWithHex:@"#cce8cf"];
    [rapidMinus.titleLabel setFont:[UIFont boldSystemFontOfSize:25.0]];
    [rapidMinus setTitle:@"-" forState:UIControlStateNormal];
    [rapidMinus setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    [rapidMinus addTarget:self action:@selector(rapidMinusClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rapidMinus];
    
    UIView *nextBricksBg = [[UIView alloc] initWithFrame:CGRectMake(self.board.right+(y-realInt(4))/2.0, self.board.bottom-realInt(4), realInt(4), realInt(4))];
//    nextBricksBg.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
    nextBricksBg.layer.borderColor = [UIColor redColor].CGColor;
    nextBricksBg.layer.borderWidth = 0.5;
    [self.view addSubview:nextBricksBg];
    
    for (NSInteger x = 0; x < 4; x ++) {
        for (NSInteger y = 0; y < 4; y ++) {
            UIView *grid = [UIView new];
            grid.backgroundColor = [UIColor colorWithHex:@"#cce8cf"];
            grid.layer.borderWidth = 0.5;
            grid.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
            grid.frame = CGRectMake(realInt(x), realInt(y), realInt(1), realInt(1));
            [nextBricksBg addSubview:grid];
        }
    }

    UIView *nextBricks = [[UIView alloc] initWithFrame:nextBricksBg.bounds];
    [nextBricksBg addSubview:nextBricks];

    UILabel *next = [[UILabel alloc] initWithFrame:CGRectMake(nextBricksBg.left, nextBricksBg.top-35, nextBricksBg.width, 35)];
    next.text = @"Next";
    next.textAlignment = NSTextAlignmentCenter;
    next.textColor = randomColor;
    next.font = [UIFont boldSystemFontOfSize:15.0];
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
    __weak typeof(self) weakSelf = self;
    self.board.gameOverBlock = ^{
        play.selected = NO;
        play.userInteractionEnabled = NO;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertRestart = [UIAlertAction actionWithTitle:@"Restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf restartClick];
        }];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Game Over" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:alert];
        [alertVC addAction:alertRestart];
        [weakSelf presentViewController:alertVC animated:YES completion:nil];
    };
    self.board.restartBlock = ^{
        totalScore = 0;
        [UIView animateWithDuration:0.01 animations:^{
            score.text = [NSString stringWithFormat:@"%zd", totalScore];
        }];
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
