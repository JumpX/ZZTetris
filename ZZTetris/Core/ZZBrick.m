//
//  ZZBrick.m
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import "ZZBrick.h"

@implementation ZZBrick

- (instancetype)initWithFrame:(CGRect)frame point:(ZZPoint *)point backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor
{
    if (self = [super initWithFrame:frame]) {
        self.point = point;
        self.backgroundColor = backgroundColor;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = borderColor.CGColor;
    }
    return self;
}

- (void)updateBrick:(ZZPoint *)point
{
    self.point = point;
}

- (ZZPoint *)downPoint
{
    return [ZZPoint createPoint:_point.x y:_point.y+1];
}

- (ZZPoint *)leftPoint
{
    return [ZZPoint createPoint:_point.x-1 y:_point.y];
}

- (ZZPoint *)rightPoint
{
    return [ZZPoint createPoint:_point.x+1 y:_point.y];
}

@end
