//
//  ZZPoint.m
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import "ZZPoint.h"

@implementation ZZPoint

+ (instancetype)createPoint:(NSInteger)x y:(NSInteger)y
{
    ZZPoint *point = [ZZPoint new];
    point.x = x;
    point.y = y;
    return point;
}

@end
