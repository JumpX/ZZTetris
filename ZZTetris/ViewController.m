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
    
    CGFloat btnTop = self.board.bottom+realInt(1);
    CGFloat btnInterval = w/8.0;
    CGFloat btnWidth = btnInterval*2+realInt(2);
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(xy-realInt(1), btnTop-realInt(1), btnWidth, btnWidth);
    [left setImage:[UIImage imageNamed:@"zzleft"] forState:UIControlStateNormal];
    [left setImageEdgeInsets:UIEdgeInsetsMake(realInt(1), realInt(1), realInt(1), realInt(1))];
    [left addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(xy+2*btnWidth-realInt(3), btnTop-realInt(1), btnWidth, btnWidth);
    [right setImage:[UIImage imageNamed:@"zzright"] forState:UIControlStateNormal];
    [right setImageEdgeInsets:UIEdgeInsetsMake(realInt(1), realInt(1), realInt(1), realInt(1))];
    [right addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
    play.frame = CGRectMake(xy+btnWidth-realInt(1), btnTop, btnWidth-realInt(2), btnWidth-realInt(2));
    [play setImage:[UIImage imageNamed:@"zzplay"] forState:UIControlStateNormal];
    [play setImage:[UIImage imageNamed:@"zzpause"] forState:UIControlStateSelected];
    [play addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:play];
    
    UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
    down.frame = CGRectMake(xy+btnWidth-realInt(2), btnTop+btnWidth-realInt(1), btnWidth, btnWidth-realInt(1));
    [down setImage:[UIImage imageNamed:@"zzdown"] forState:UIControlStateNormal];
    [down setImageEdgeInsets:UIEdgeInsetsMake(0, realInt(1), realInt(1), realInt(1))];
    [down addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:down];

    UIButton *reversal = [UIButton buttonWithType:UIButtonTypeCustom];
    reversal.frame = CGRectMake(xy+2*btnWidth, btnTop+realInt(3), btnWidth, btnWidth);
    [reversal setImage:[UIImage imageNamed:@"zzreversal"] forState:UIControlStateNormal];
    [reversal setImageEdgeInsets:UIEdgeInsetsMake(-realInt(1), -realInt(1), -realInt(1), -realInt(1))];
    [reversal addTarget:self action:@selector(reversalClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reversal];

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
    [rapidPlus.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rapidPlus setTitle:@"+" forState:UIControlStateNormal];
    [rapidPlus addTarget:self action:@selector(rapidPlusClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rapidPlus];
    
    UIButton *rapidMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    rapidMinus.frame = CGRectMake(rapidLabel.centerX, rapidLabel.bottom, rapidLabel.width/2.0, rapidLabel.width/2.0);
    rapidMinus.layer.borderWidth = 0.5;
    rapidMinus.layer.borderColor = [UIColor redColor].CGColor;
    rapidMinus.backgroundColor = [UIColor lightGrayColor];
    [rapidMinus.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rapidMinus setTitle:@"-" forState:UIControlStateNormal];
    [rapidMinus addTarget:self action:@selector(rapidMinusClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rapidMinus];
    
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
