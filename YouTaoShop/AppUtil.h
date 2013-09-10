//
//  AppUtil.h
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-30.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+MLPFlatColors.h"

static NSString *userSharedSucceedKey = @"sharedSucceed";

@interface AppUtil : NSObject

+ (NSString*)GetCurTime;

+ (BOOL)isTimeExpire:(NSString*)timeS timeE:(NSString*)timeE;

+ (BOOL) IsEnable3G;

+ (BOOL) IsEnableWIFI;

+ (CGFloat) convertFanliNum:(CGFloat)originalFanli;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@end
