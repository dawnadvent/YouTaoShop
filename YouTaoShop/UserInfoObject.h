//
//  UserInfoObject.h
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-17.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFAV_STORE  @"favTaobaoProductArray"

@interface UserInfoObject : NSObject


//fav set
+ (NSMutableArray *)getUserFavProduct;

+ (void)addFavToFav:(NSMutableDictionary *)dic;

+ (void)deleteFavByPid:(NSNumber *)pid;

+ (NSMutableDictionary *)getFavDicByPid:(NSNumber *)pid;

@end
