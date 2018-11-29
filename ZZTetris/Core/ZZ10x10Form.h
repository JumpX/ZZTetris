//
//  ZZ10x10Form.h
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBrick.h"

@interface ZZ10x10Form : UIView

@property (nonatomic, copy) void(^gameOverBlock)(void);
@property (nonatomic, copy) void(^restartBlock)(void);
@property (nonatomic, copy) void(^scoreBlock)(NSInteger score);
@property (nonatomic, copy) void(^nextBricksBlock)(NSArray<ZZBrick *> *bricks);

- (void)leftClick;
- (void)rightClick;
- (void)downClick;
- (void)reversalClick;
- (void)restartClick;
- (void)playClick:(BOOL)isPlaying;

@end
