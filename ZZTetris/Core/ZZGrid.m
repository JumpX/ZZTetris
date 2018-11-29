//
//  ZZGrid.m
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import "ZZGrid.h"

@implementation ZZGrid

- (instancetype)initWithType:(ZZBrickType)type
{
    if (self = [super init]) {
        NSArray *brickGrids = [self brickGridsByType:type];
        ZZPoint *point = brickGrids.lastObject;
        self.w = point.x+1;
        self.h = [self getHeightWithBrickGrids:brickGrids];
        self.brickGrids = brickGrids;
        self.brickType = type;
        self.brickColor = [self brickColors][arc4random()%4];
        self.borderColor = [UIColor whiteColor];
    }
    return self;
}

- (NSArray *)brickColors
{
    return @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor],[UIColor greenColor]];
}

- (NSInteger)getHeightWithBrickGrids:(NSArray<ZZPoint *> *)brickGrids
{
    __block NSInteger height = 0;
    [brickGrids enumerateObjectsUsingBlock:^(ZZPoint * _Nonnull point, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger y = -point.y;
        if (y > height) {
            height = y;
        }
    }];
    return height;
}

- (ZZBrickType)reversalBrickType
{
    switch (self.brickType) {
        case ZZBrickTypeI:
            return ZZBrickTypeIR;
        case ZZBrickTypeIR:
            return ZZBrickTypeI;
        case ZZBrickTypeL:
            return ZZBrickTypeL1;
        case ZZBrickTypeL1:
            return ZZBrickTypeL2;
        case ZZBrickTypeL2:
            return ZZBrickTypeL3;
        case ZZBrickTypeL3:
            return ZZBrickTypeL;
        case ZZBrickTypeLR:
            return ZZBrickTypeLR1;
        case ZZBrickTypeLR1:
            return ZZBrickTypeLR2;
        case ZZBrickTypeLR2:
            return ZZBrickTypeLR3;
        case ZZBrickTypeLR3:
            return ZZBrickTypeLR;
        case ZZBrickTypeO:
            return ZZBrickTypeO;
        case ZZBrickTypeT:
            return ZZBrickTypeT1;
        case ZZBrickTypeT1:
            return ZZBrickTypeT2;
        case ZZBrickTypeT2:
            return ZZBrickTypeT3;
        case ZZBrickTypeT3:
            return ZZBrickTypeT;
        case ZZBrickTypeZ:
            return ZZBrickTypeZ1;
        case ZZBrickTypeZ1:
            return ZZBrickTypeZ;
        case ZZBrickTypeZR:
            return ZZBrickTypeZR1;
        case ZZBrickTypeZR1:
            return ZZBrickTypeZR;
            
        default:
            break;
    }
}

- (NSArray *)brickGridsByType:(ZZBrickType)type
{
    NSMutableArray *brickGrids = [NSMutableArray new];
    ZZPoint *point1;
    ZZPoint *point2;
    ZZPoint *point3;
    ZZPoint *point4;
    switch (type) {
        case ZZBrickTypeI:
        {
            point1 = [ZZPoint createPoint:0 y:-1];
            point2 = [ZZPoint createPoint:1 y:-1];
            point3 = [ZZPoint createPoint:2 y:-1];
            point4 = [ZZPoint createPoint:3 y:-1];
        }
            break;

        case ZZBrickTypeIR:
        {
            point1 = [ZZPoint createPoint:0 y:-4];
            point2 = [ZZPoint createPoint:0 y:-3];
            point3 = [ZZPoint createPoint:0 y:-2];
            point4 = [ZZPoint createPoint:0 y:-1];
        }
            break;

        case ZZBrickTypeL:
        {
            point1 = [ZZPoint createPoint:0 y:-3];
            point2 = [ZZPoint createPoint:0 y:-2];
            point3 = [ZZPoint createPoint:0 y:-1];
            point4 = [ZZPoint createPoint:1 y:-1];
        }
            break;

        case ZZBrickTypeLR:
        {
            point1 = [ZZPoint createPoint:0 y:-1];
            point2 = [ZZPoint createPoint:1 y:-3];
            point3 = [ZZPoint createPoint:1 y:-2];
            point4 = [ZZPoint createPoint:1 y:-1];
        }
            break;

        case ZZBrickTypeO:
        {
            point1 = [ZZPoint createPoint:0 y:-2];
            point2 = [ZZPoint createPoint:0 y:-1];
            point3 = [ZZPoint createPoint:1 y:-2];
            point4 = [ZZPoint createPoint:1 y:-1];
        }
            break;

        case ZZBrickTypeT:
        {
            point1 = [ZZPoint createPoint:0 y:-2];
            point2 = [ZZPoint createPoint:1 y:-2];
            point3 = [ZZPoint createPoint:1 y:-1];
            point4 = [ZZPoint createPoint:2 y:-2];
        }
            break;

        case ZZBrickTypeZ:
        {
            point1 = [ZZPoint createPoint:0 y:-2];
            point2 = [ZZPoint createPoint:1 y:-2];
            point3 = [ZZPoint createPoint:1 y:-1];
            point4 = [ZZPoint createPoint:2 y:-1];
        }
            break;

        case ZZBrickTypeZR:
        {
            point1 = [ZZPoint createPoint:0 y:-1];
            point2 = [ZZPoint createPoint:1 y:-2];
            point3 = [ZZPoint createPoint:1 y:-1];
            point4 = [ZZPoint createPoint:2 y:-2];
        }
            break;

        case ZZBrickTypeL1:
        {
            point1 = [ZZPoint createPoint:0 y:-2];
            point2 = [ZZPoint createPoint:0 y:-1];
            point3 = [ZZPoint createPoint:1 y:-2];
            point4 = [ZZPoint createPoint:2 y:-2];
        }
            break;

        case ZZBrickTypeL2:
        {
            point1 = [ZZPoint createPoint:0 y:-3];
            point2 = [ZZPoint createPoint:1 y:-3];
            point3 = [ZZPoint createPoint:1 y:-2];
            point4 = [ZZPoint createPoint:1 y:-1];
        }
            break;

        case ZZBrickTypeL3:
        {
            point1 = [ZZPoint createPoint:0 y:-1];
            point2 = [ZZPoint createPoint:1 y:-1];
            point3 = [ZZPoint createPoint:2 y:-2];
            point4 = [ZZPoint createPoint:2 y:-1];
        }
            break;

        case ZZBrickTypeLR1:
        {
            point1 = [ZZPoint createPoint:0 y:-2];
            point2 = [ZZPoint createPoint:0 y:-1];
            point3 = [ZZPoint createPoint:1 y:-1];
            point4 = [ZZPoint createPoint:2 y:-1];
        }
            break;

        case ZZBrickTypeLR2:
        {
            point1 = [ZZPoint createPoint:0 y:-3];
            point2 = [ZZPoint createPoint:0 y:-2];
            point3 = [ZZPoint createPoint:0 y:-1];
            point4 = [ZZPoint createPoint:1 y:-3];
        }
            break;

        case ZZBrickTypeLR3:
        {
            point1 = [ZZPoint createPoint:0 y:-2];
            point2 = [ZZPoint createPoint:1 y:-2];
            point3 = [ZZPoint createPoint:2 y:-2];
            point4 = [ZZPoint createPoint:2 y:-1];
        }
            break;

        case ZZBrickTypeT1:
        {
            point1 = [ZZPoint createPoint:0 y:-2];
            point2 = [ZZPoint createPoint:1 y:-3];
            point3 = [ZZPoint createPoint:1 y:-2];
            point4 = [ZZPoint createPoint:1 y:-1];
        }
            break;

        case ZZBrickTypeT2:
        {
            point1 = [ZZPoint createPoint:0 y:-1];
            point2 = [ZZPoint createPoint:1 y:-2];
            point3 = [ZZPoint createPoint:1 y:-1];
            point4 = [ZZPoint createPoint:2 y:-1];
        }
            break;

        case ZZBrickTypeT3:
        {
            point1 = [ZZPoint createPoint:0 y:-3];
            point2 = [ZZPoint createPoint:0 y:-2];
            point3 = [ZZPoint createPoint:0 y:-1];
            point4 = [ZZPoint createPoint:1 y:-2];
        }
            break;

        case ZZBrickTypeZ1:
        {
            point1 = [ZZPoint createPoint:0 y:-2];
            point2 = [ZZPoint createPoint:0 y:-1];
            point3 = [ZZPoint createPoint:1 y:-3];
            point4 = [ZZPoint createPoint:1 y:-2];
        }
            break;

        case ZZBrickTypeZR1:
        {
            point1 = [ZZPoint createPoint:0 y:-3];
            point2 = [ZZPoint createPoint:0 y:-2];
            point3 = [ZZPoint createPoint:1 y:-2];
            point4 = [ZZPoint createPoint:1 y:-1];
        }
            break;

        default:
        {
            point1 = [ZZPoint createPoint:0 y:-1];
            point2 = [ZZPoint createPoint:1 y:-1];
            point3 = [ZZPoint createPoint:2 y:-1];
            point4 = [ZZPoint createPoint:3 y:-1];
        }
            break;
    }
    [brickGrids addObject:point1];
    [brickGrids addObject:point2];
    [brickGrids addObject:point3];
    [brickGrids addObject:point4];
    return brickGrids;
}

@end
