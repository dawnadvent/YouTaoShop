//
//  FollowOrderRules.m
//  fanli
//
//  Created by 吴江伟 on 13-9-12.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "FollowOrderRules.h"

#define FIRST_SEPERATE  @"@@@@"
#define SECOND_SEPERATE @"****"

#define kTaobaoShopCartUrlKey      @"TaobaoShopCartUrl"
#define kTaobaoSingleBuyUrlKey     @"SingleProductFollowUrl"

#define kTaobaoShopCartDicKey      @"FollowShopCartDic"
#define kTaobaoSingleUrlDicKey     @"FollowBuyProductDic"

static NSString *webKey0 = @"shouldStart";
static NSString *webKey1 = @"finished";

/*TaobaoShopCartUrl format:
            webKey@@@@Url@@@@key0@@@@key1...
 */
/*SingleProductFollowUrl format:
            WebKey@@@@Url0****Url1...
 */

/*FollowShopCartDic format:
            NameJs@@@@PidJs
 */

/*FollowBuyProductDic format:
            NameJs0***NameJs1...@@@@PidJs(webUrlPid/js)
 */

@implementation FollowOrderRules

+ (NSArray *)convertFirstLevelStringToArray:(NSString *)string
{
    return [string componentsSeparatedByString:FIRST_SEPERATE];
}

+ (NSArray *)convertSecondLevelStringToArray:(NSString *)string
{
    return [string componentsSeparatedByString:SECOND_SEPERATE];
}

#pragma mark -
#pragma mark - 判断是在Webview的什么时候触发跟单逻辑——webview即将开始加载还是加载结束之后

+ (BOOL)isTaobaoShopCartPreWebView
{
    NSString *shopCartUrlKey = [MobClick getConfigParams:kTaobaoShopCartUrlKey];
    NSArray *shopKeyArray = [FollowOrderRules convertFirstLevelStringToArray:shopCartUrlKey];
    
    if (!shopKeyArray || !shopKeyArray.count) {
        //默认webview开始加载的时候 开始购物车跟单
        return YES;
    }
    
    NSString *webKey = [shopKeyArray objectAtIndex:0];
    
    return [webKey isEqualToString:webKey0] ? YES : NO;
}

+ (BOOL)isSingleUrlPreWebView
{
    NSString *singleUrlKey = [MobClick getConfigParams:kTaobaoSingleBuyUrlKey];
    NSArray *sinfleKeyArray = [FollowOrderRules convertFirstLevelStringToArray:singleUrlKey];
    
    if (!sinfleKeyArray || !sinfleKeyArray.count) {
        //默认webview开始加载的时候 开始购物车跟单
        return NO;
    }
    
    NSString *webKey = [sinfleKeyArray objectAtIndex:0];
    
    return [webKey isEqualToString:webKey0] ? YES : NO;
}

#pragma mark -
#pragma mark - 判断Webview的当前链接是不是需要触发跟单逻辑

+ (BOOL)isUrlSingleProduct:(NSString *)webUrlString
{
    NSString *singleUrlKey = [MobClick getConfigParams:kTaobaoSingleBuyUrlKey];
    NSArray *singeKeyArray = [FollowOrderRules convertFirstLevelStringToArray:singleUrlKey];
    
    if (!singeKeyArray || !singeKeyArray.count) {
        //默认内置判断条件
        if ([webUrlString hasPrefix:@"http://d.m.taobao.com/confirm.htm"]) {
            return YES;
        }

        return NO;
    }
    
    for (int i = 1; i < singeKeyArray.count ; i++) {
        NSString *key = [singeKeyArray objectAtIndex:i];
        if ([key hasPrefix:@"http://"]) {
            if (![webUrlString hasPrefix:key]) {
                return NO;
            }else{
                NSRange range = [webUrlString rangeOfString:key];
                if (range.location == NSNotFound) {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

+ (BOOL)isUrlTaobaoShopCart:(NSString *)webUrlString
{
    NSString *shopCartUrlKey = [MobClick getConfigParams:kTaobaoSingleBuyUrlKey];
    NSArray *shopKeyArray = [FollowOrderRules convertFirstLevelStringToArray:shopCartUrlKey];
    
    if (!shopKeyArray || !shopKeyArray.count) {
        //默认内置判断条件
        NSString *key = @"order!cartIds=";
        NSString *taobaoPreUrl = @"http://h5.m.taobao.com/cart/index.htm";
        NSRange rang = [webUrlString rangeOfString:key];
        if ([webUrlString hasPrefix:taobaoPreUrl] && rang.length) {
            return YES;
        }
        
        return NO;
    }
    
    for (int i = 1; i < shopKeyArray.count ; i++) {
        NSString *key = [shopKeyArray objectAtIndex:i];
        if ([webUrlString hasPrefix:key]) {
            if ([webUrlString hasPrefix:key]) {
                return YES;
            }
        }
    }
    
    return NO;
}

+ (NSString *)getShopCartKeyString
{
    return [MobClick getConfigParams:kTaobaoShopCartDicKey];
}

+ (NSString *)getSingleUrlKeyString
{
    return [MobClick getConfigParams:kTaobaoSingleUrlDicKey];
}

+(BOOL)preLoadGetFollowInfoString:(UIWebView *)webview Url:(NSString *)webUrl ProductNameString:(NSString **)nameString ProductPidString:(NSString *)pidString
{
    if ([FollowOrderRules isUrlTaobaoShopCart:webUrl] && [FollowOrderRules isTaobaoShopCartPreWebView]) {
        //购物车页面跟单规则 —— 用户进入淘宝购物车页面购买商品
        NSString *shopCartString = [FollowOrderRules getShopCartKeyString];
    }else{
        //单品页面跟单规则 —— 用户直接购买
        NSString *buyNowString = [FollowOrderRules getSingleUrlKeyString];
    }
    
    
}

+(BOOL)finishLoadGetFollowInfoString:(UIWebView *)webview Url:(NSString *)webUrl ProductNameString:(NSString **)nameString ProductPidString:(NSString *)pidString
{
    //
}

@end
