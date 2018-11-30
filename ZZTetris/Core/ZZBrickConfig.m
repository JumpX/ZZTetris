//
//  ZZBrickConfig.m
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/29.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import "ZZBrickConfig.h"

@implementation ZZPoint

+ (instancetype)createPoint:(NSInteger)x y:(NSInteger)y
{
    ZZPoint *point = [ZZPoint new];
    point.x = x;
    point.y = y;
    return point;
}

@end

@implementation ZZBrickConfig

- (instancetype)initWithType:(ZZBrickType)type
{
    if (self = [super init]) {
        NSArray *brickPoints = [self brickGridsByType:type];
        ZZPoint *point = brickPoints.lastObject;
        self.w = point.x+1;
        self.h = [self getHeightWithPoints:brickPoints];
        self.brickPoints = brickPoints;
        self.brickType = type;
        self.brickColor = [self brickColors][arc4random()%4];
        self.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    }
    return self;
}

- (NSArray *)brickColors
{
    return @[[UIColor colorWithHex:@"#dd7e6b"],
             [UIColor colorWithHex:@"#f6b26b"],
             [UIColor colorWithHex:@"#3d85c6"],
             [UIColor colorWithHex:@"#6aa84f"]];
}

- (NSInteger)getHeightWithPoints:(NSArray<ZZPoint *> *)brickPoints
{
    __block NSInteger height = 0;
    [brickPoints enumerateObjectsUsingBlock:^(ZZPoint * _Nonnull point, NSUInteger idx, BOOL * _Nonnull stop) {
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

@implementation UIColor (ZZRandom)

+ (UIColor *)randomColor
{
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *color = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)randomColor:(NSInteger)random
{
    NSInteger aRedValue = random % 255;
    NSInteger aGreenValue = random % 255;
    NSInteger aBlueValue = random % 255;
    UIColor *color = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return color;
}

@end

@implementation UIColor (ZZExtension)

+ (UIColor *)colorWithHex:(NSString *)hex defaultHex:(NSString *)defaultHex
{
    return [UIColor colorWithHex:hex defaultHex:defaultHex alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSString *)hex defaultHex:(NSString *)defaultHex alpha:(CGFloat)alpha
{
    UIColor *color = [UIColor colorWithHex:hex alpha:alpha];
    if (color == [UIColor clearColor]) {
        return [UIColor colorWithHex:defaultHex alpha:alpha];
    } else return color;
}

+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha
{
    NSString *hexString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([hexString length] < 6) {
        return [UIColor clearColor];
    }
    if ([hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    }
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    if ([hexString length] != 6) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [hexString substringWithRange:range];
    range.location = 2;
    NSString *gString = [hexString substringWithRange:range];
    range.location = 4;
    NSString *bString = [hexString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(float)r / 255.0f green:(float)g / 255.0f blue:(float)b / 255.0f alpha:alpha];
}

+ (UIColor *)colorWithHex:(NSString *)hex
{
    return [self colorWithHex:hex alpha:1.0];
}

@end

@implementation UIView (ZZAdd)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end

