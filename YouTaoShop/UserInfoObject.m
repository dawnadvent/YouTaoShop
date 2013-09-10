//
//  UserInfoObject.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-17.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "UserInfoObject.h"

NSMutableArray *gFavTaobaoProductArray = nil;


@implementation UserInfoObject

+ (NSMutableArray *)getUserFavProduct
{
    if (gFavTaobaoProductArray) {
        return gFavTaobaoProductArray;
    }
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    
    //从user defaults中获取数据:
    
    NSMutableArray *array = [accountDefaults objectForKey:kFAV_STORE];
    
    if (array && array.count) {
        gFavTaobaoProductArray = [[NSMutableArray alloc] initWithArray:array];
    }else{
        gFavTaobaoProductArray = [[NSMutableArray alloc] initWithArray:nil];
    }
    
    return gFavTaobaoProductArray;
}

+ (void)addFavToFav:(NSMutableDictionary *)dic
{
    SAFE_INSTANCE_CHECK(dic)
    
    [[UserInfoObject getUserFavProduct] addObject:dic];
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:gFavTaobaoProductArray forKey:kFAV_STORE];
}

+ (void)deleteFavByPid:(NSNumber *)pid
{
    NSMutableDictionary *dic = [UserInfoObject getFavDicByPid:pid];
    if (dic) {
        [[UserInfoObject getUserFavProduct] removeObject:dic];
    }
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:gFavTaobaoProductArray forKey:kFAV_STORE];
}

+ (NSMutableDictionary *)getFavDicByPid:(NSNumber *)pid
{
    for (NSMutableDictionary *dic in [UserInfoObject getUserFavProduct]) {
        NSNumber *tId = [dic objectForKey:@"num_iid"];
        if (tId.longLongValue == pid.longLongValue) {
            return dic;
        }
    }
    
    return nil;
}


@end
