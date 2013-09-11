//
//  LoginUserInfo.h
//  TradePluginDemo
//
//  Created by tianqiao on 12-11-14.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUserInfo : NSObject


+(LoginUserInfo *)sharedInstance;
-(void)registerUserInfo:(NSString *)userId;

@property (nonatomic,copy) NSString *appkey;
@property (nonatomic,copy) NSString *appSecret;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *callBackUrl;

@end
