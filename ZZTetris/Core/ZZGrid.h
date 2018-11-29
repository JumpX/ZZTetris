//
//  ZZGrid.h
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZZTetrisDefine.h"
#import "ZZColor.h"
#import "ZZPoint.h"

@interface ZZGrid : NSObject

@property (nonatomic, assign) NSInteger     w;
@property (nonatomic, assign) NSInteger     h;
@property (nonatomic, strong) UIColor       *brickColor;
@property (nonatomic, strong) UIColor       *borderColor;
@property (nonatomic, assign) ZZBrickType   brickType;
@property (nonatomic, strong) NSArray<ZZPoint *> *brickGrids;
@property (nonatomic, assign) ZZBrickType   reversalBrickType;

- (instancetype)initWithType:(ZZBrickType)type;

@end
