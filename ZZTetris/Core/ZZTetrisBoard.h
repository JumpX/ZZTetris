//
//  ZZTetrisBoard.h
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/29.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBrickConfig.h"
#import "ZZBrick.h"

@interface ZZTetrisBoard : UIView

@property (nonatomic, copy) void(^rapidPlusBlock)(NSInteger rapidLevel);
@property (nonatomic, copy) void(^rapidMinusBlock)(NSInteger rapidLevel);
@property (nonatomic, copy) void(^nextBricksBlock)(NSArray<ZZBrick *> *bricks);
@property (nonatomic, copy) void(^scoreBlock)(NSInteger score);
@property (nonatomic, copy) void(^gameOverBlock)(void);
@property (nonatomic, copy) void(^restartBlock)(void);

- (void)rapidPlusClick;
- (void)rapidMinusClick;
- (void)leftClick;
- (void)rightClick;
- (void)downClick;
- (void)reversalClick;
- (void)restartClick;
- (void)playClick:(BOOL)isPlaying;

@end
