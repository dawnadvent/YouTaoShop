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
        sharedInstance.appSecret = @"493f315cf4f8a665ac4b790c90750900";
        sharedInstance.appkey = @"21310245";
        sharedInstance.callBackUrl = @"jdyAuthBack://";
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
