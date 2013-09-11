//
//  LoginUserInfo.m
//  TradePluginDemo
//
//  Created by tianqiao on 12-11-14.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "LoginUserInfo.h"

@implementation LoginUserInfo
static LoginUserInfo *sharedInstance = nil;
@synthesize userId;
@synthesize userName;
@synthesize appkey;
@synthesize appSecret;
@synthesize callBackUrl;

+(LoginUserInfo *)sharedInstance{
    if (!sharedInstance) {
		sharedInstance=[[self alloc] init];
        sharedInstance.appSecret = @"a4d7290134b738c66823d173822843dc";
        //sharedInstance.appkey = @"21310301";
        sharedInstance.appkey = @"21102355";
        sharedInstance.callBackUrl = @"jdyTradeBack://";
//        sharedInstance.userId = @"88591187";//商家测试账号1 pass：huijin@fuwu
    }
    return sharedInstance;
}

-(void)registerUserInfo:(NSString *)aUserId{
    sharedInstance = [LoginUserInfo sharedInstance];
    sharedInstance.userId = aUserId;
}

- (void)dealloc
{
    [LoginUserInfo release];
    [super dealloc];
}
@end
