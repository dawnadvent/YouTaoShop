//
//  AppUtil.m
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-30.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "AppUtil.h"
#import "Reachability.h"

@implementation AppUtil

#define MAX_SPACE_TIME      11*60

+ (NSString*)GetCurTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    NSString*timeString=[formatter stringFromDate: [NSDate date]];
    
    [formatter release];
    
    
    return timeString;
}

+ (double)GetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE

{
    double timeDiff = 0.0;
    
    //保护
    if (!timeS || !timeE) {
        return MAX_SPACE_TIME + 100;
    }
    
    NSDateFormatter *formatters = [[NSDateFormatter alloc] init];
    [formatters setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *dateS = [formatters dateFromString:timeS];
    
    NSDateFormatter *formatterE = [[NSDateFormatter alloc] init];
    [formatterE setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *dateE = [formatterE dateFromString:timeE];
    
    timeDiff = [dateE timeIntervalSinceDate:dateS];
    
    NSLog(@"timeDiff %f", timeDiff);
    [formatters release];
    [formatterE release];
    return timeDiff;
    
}

+ (BOOL)isTimeExpire:(NSString*)timeS timeE:(NSString*)timeE
{
    double space = [AppUtil GetStringTimeDiff:timeS timeE:timeE];
    
    BOOL retB = (space >= MAX_SPACE_TIME) ? YES : NO;
    
    return retB;
}

// 是否wifi
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
// 是否3G
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

+ (CGFloat) convertFanliNum:(CGFloat)originalFanli
{
    if(originalFanli < 1)
    {
        //少于0.25元，不给用户显示有多少返利，直接无返利
        return 0;
    }else if (originalFanli < 5)
    {
        return originalFanli*0.6;
    }else if (originalFanli < 15)
    {
        return originalFanli*0.5;
    }else{
        return originalFanli*0.45;
    }
    
    return originalFanli * 0.45;
}

@end
