//
//  taobaoTrackObject.m
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-30.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "taobaoTrackObject.h"
#import "Singleton.h"
#import "AppUtil.h"

@implementation taobaoTrackObject

static NSMutableArray *global_linked_taobao_product_ids = nil;

+ (NSMutableArray *)sharedInstance
{
    @synchronized(global_linked_taobao_product_ids)
    {
        if (!global_linked_taobao_product_ids) {
            global_linked_taobao_product_ids = [[NSMutableArray alloc] init];
        }
    }
    //NSLog(@"global_linked_taobao_product_ids %@", global_linked_taobao_product_ids);
    return global_linked_taobao_product_ids;
}

-(void)dealloc
{
    global_linked_taobao_product_ids = nil;
    [super dealloc];
}

+(void)AddTaobaokeInfoToSInstance:(NSDictionary *)taobaokeDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:taobaokeDic];
    
    //该处都是用户浏览
    [dic setObject:[NSNumber numberWithInt:e_User_Scan_Product] forKey:kIS_PRODUCT_BE_FOLLOWED_KEY];
    [dic setObject:[AppUtil GetCurTime] forKey:@"date"];
    [[taobaoTrackObject sharedInstance] addObject:dic];
}

+ (BOOL)isThisTidNeedFollow:(NSNumber *)tid
{
    for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
        NSNumber *dTid = [dic objectForKey:@"num_iid"];
        if (dTid.longLongValue == tid.longLongValue) {
            
            //跟单是否过期
            NSString *oldDate = [dic objectForKey:@"followdate"];
            if([AppUtil isTimeExpire:oldDate timeE:[AppUtil GetCurTime]])
            {
                //过期 需要重新跟单
                return YES;
            }else
            {
                //未过期
                return NO;
            }
        }
    }
    //tid不存在
    NSLog(@"isThisTidNeedFollow warning not find this tid in trackObject array");
    return YES;
}

+ (NSMutableDictionary *)getTaobaokeInfoByPid:(NSNumber *)tid
{
    for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
        NSNumber *dTid = [dic objectForKey:@"num_iid"];
        if (dTid.longLongValue == tid.longLongValue) {
            return dic;
        }
    }
    return nil;
}


+ (void)setProduct:(NSNumber *)tid RecordType:(eProcutRecordType)productRecordType
{
    NSString *shop_click_url = nil;
    NSString *follow_timer = nil;
    
    for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
        //NSLog(@"dic %@", dic);
        NSNumber *dTid = [dic objectForKey:@"num_iid"];
        if (dTid.longLongValue == tid.longLongValue) {
            [dic setObject:[NSNumber numberWithInt:productRecordType] forKey:kIS_PRODUCT_BE_FOLLOWED_KEY];
            //刷新跟单时间
            follow_timer = [AppUtil GetCurTime];
            [dic setObject:follow_timer forKey:@"followdate"];
            shop_click_url = [dic objectForKey:@"shop_click_url"];
            break;
        }
    }
    
    NSLog(@"shop_click_url class %@", [shop_click_url class]);
    
    //一个宝贝跟单成功，所有该宝贝所属店铺的宝贝跟单成功,刷新跟单时间
    if (shop_click_url) {
        for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
            NSString *sid = [dic objectForKey:@"shop_click_url"];
            if ([sid isEqualToString:shop_click_url]) {
                [dic setObject:follow_timer forKey:@"followdate"];
                //[dic setObject:[NSNumber numberWithInt:productRecordType] forKey:kIS_PRODUCT_BE_FOLLOWED_KEY];
            }
        }
    }else
        NSLog(@"setProduct warning not find this tid in trackObject array");
}

+ (void)setProduct:(NSNumber *)tid CommissionRate:(NSNumber *)rate
{
    for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
        NSLog(@"CommissionRate dic %@", dic);
        NSNumber *dTid = [dic objectForKey:@"num_iid"];
        if (dTid.longLongValue == tid.longLongValue) {
            //刷新返利比值
            //和淘宝commission_rate规则一致
            NSNumber *num = [NSNumber numberWithFloat:rate.floatValue * 10000];
            [dic setObject:num forKey:@"commission_rate"];
            return;
        }
    }
    
    NSLog(@"unfind juhuasuan taobaoke info,tid = %lld", tid.longLongValue);
}

@end
