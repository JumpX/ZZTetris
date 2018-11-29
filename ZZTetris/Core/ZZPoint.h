//
//  ZZPoint.h
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZPoint : NSObject

@property (nonatomic, assign) NSInteger     x;
@property (nonatomic, assign) NSInteger     y;

+ (instancetype)createPoint:(NSInteger)x y:(NSInteger)y;

@end
