//
//  ZZBrick.h
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import "ZZBrickConfig.h"

@interface ZZBrick : UIView

@property (nonatomic, strong) ZZBrickConfig *config;
@property (nonatomic, strong) ZZPoint *point;

@property (nonatomic, strong, readonly) ZZPoint *leftPoint;
@property (nonatomic, strong, readonly) ZZPoint *rightPoint;
@property (nonatomic, strong, readonly) ZZPoint *downPoint;

- (instancetype)initWithFrame:(CGRect)frame
                        point:(ZZPoint *)point
              backgroundColor:(UIColor *)backgroundColor
                  borderColor:(UIColor *)borderColor;

- (void)updateBrick:(ZZPoint *)point;

@end
