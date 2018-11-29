//
//  ZZColor.h
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZZColor : NSObject

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
