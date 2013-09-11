//
//  TopApiCallUtil.m
//  TradePluginDemo
//
//  Created by tianqiao on 12-11-14.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "TopApiCallUtil.h"
#import "LoginUserInfo.h"
#import "SBJSON.h"
#import "TopIOSClient.h"
#import "TopApiResponse.h"

@implementation TopApiCallUtil

+(NSString *)runTql:(NSString *)tql
{
    NSLog(@"run tql: %@",tql);
    NSString * appkey = [[LoginUserInfo sharedInstance] appkey];
    NSString * uid = [[LoginUserInfo sharedInstance] userId];
    TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:appkey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:tql forKey:@"ql"];
    
    TopApiResponse * response = [iosClient tql:@"GET" params:params userId:uid];
    
    NSString *data = [response content];
    
    NSLog(@"tql result: %@",data);
    
    return data;
    
}
+(NSDictionary *)getJsonObject:(NSString *)tql
{
    return [self getJsonObject:tql method:@"GET"];
}

+(NSDictionary *)getJsonObject:(NSString *)tql method:(NSString *) method
{
    
    NSString *data = [self runTql:tql];    
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *jsonDic = [json objectWithString:data error:nil];
    
    return jsonDic;
}

/**
 {"error_response":{"code":15,"msg":"Remote service error","sub_code":"isv.shop-not-exist:invalid-shop","sub_msg":"您好，您没有可访问的店铺！"}}
 **/
+(NSString *)getError:(NSDictionary *)jsonObject
{
    id error_response = [jsonObject objectForKey:@"error_response"];
    if(error_response==nil){
        return nil;
    }else{
        NSString * sub_msg = [error_response objectForKey:@"sub_msg"];
        if(sub_msg==nil){
            sub_msg = [error_response objectForKey:@"msg"];
        }
        if(sub_msg==nil){
            sub_msg = @"调用API接口出现错误.";
        }
        return sub_msg;
    }

}
@end
