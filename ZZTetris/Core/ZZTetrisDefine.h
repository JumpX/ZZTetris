//
//  ZZTetrisDefine.h
//  ZZTetris
//
//  Created by 徐勉俊 on 2018/11/27.
//  Copyright © 2018 Jungle. All rights reserved.
//

#ifndef ZZTetrisDefine_h
#define ZZTetrisDefine_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 规格为12x20的游戏盘子，基准值为20像素
static NSInteger BoardWidth = 12;
static NSInteger BoardHeight = 20;
static NSInteger BoardBaseInt = 20;
static inline NSInteger realInt(NSInteger tempInt) {
    return tempInt*BoardBaseInt;
}

// 方块移动方向
typedef NS_ENUM(NSInteger, ZZBrickDirection) {
    ZZBrickDirectionDown = 0,
    ZZBrickDirectionLeft,
    ZZBrickDirectionRight
};

// 方块类型
typedef NS_ENUM(NSInteger, ZZBrickType) {
    // base type
    ZZBrickTypeI = 0,       // I型
    ZZBrickTypeIR,          // 反I型
    ZZBrickTypeL,           // L型
    ZZBrickTypeLR,          // 反L型
    ZZBrickTypeO,           // 田字型
    ZZBrickTypeT,           // T型
    ZZBrickTypeZ,           // Z型
    ZZBrickTypeZR,          // 反Z型
    
    // reversal type
    ZZBrickTypeL1,          // L1型
    ZZBrickTypeL2,          // L2型
    ZZBrickTypeL3,          // L3型
    ZZBrickTypeLR1,         // 反L型1
    ZZBrickTypeLR2,         // 反L型2
    ZZBrickTypeLR3,         // 反L型3
    ZZBrickTypeT1,          // T型1
    ZZBrickTypeT2,          // T型2
    ZZBrickTypeT3,          // T型3
    ZZBrickTypeZ1,          // Z型1
    ZZBrickTypeZR1,         // 反Z型1
};

#endif /* ZZTetrisDefine_h */
