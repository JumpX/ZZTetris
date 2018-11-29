//
//  ZZBrickConfig.h
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/29.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import "ZZTetrisDefine.h"

@interface ZZPoint : NSObject

@property (nonatomic, assign) NSInteger     x;
@property (nonatomic, assign) NSInteger     y;
+ (instancetype)createPoint:(NSInteger)x y:(NSInteger)y;

@end

@interface ZZBrickConfig : NSObject

@property (nonatomic, assign) NSInteger     w;
@property (nonatomic, assign) NSInteger     h;
@property (nonatomic, strong) UIColor       *brickColor;
@property (nonatomic, strong) UIColor       *borderColor;
@property (nonatomic, assign) ZZBrickType   brickType;
@property (nonatomic, assign) ZZBrickType   reversalBrickType;
@property (nonatomic, strong) NSArray<ZZPoint *> *brickPoints;

- (instancetype)initWithType:(ZZBrickType)type;

@end

@interface UIColor (ZZRandom)

+ (UIColor *)randomColor;
+ (UIColor *)randomColor:(NSInteger)random;

@end

@interface UIColor (ZZExtension)

+ (UIColor *)colorWithHex:(NSString *)hex;
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(NSString *)hex defaultHex:(NSString *)defaultHex;
+ (UIColor *)colorWithHex:(NSString *)hex defaultHex:(NSString *)defaultHex alpha:(CGFloat)alpha;

@end

@interface UIView (ZZAdd)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

@end
