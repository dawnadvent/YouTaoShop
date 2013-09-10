//
//  taobaoUtil.h
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-29.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface taobaoUtil : NSObject

+ (NSString *)getTaobaoIdWithDic:(NSString *)url;

+ (NSString *)getTaobaoIdWithUrlReg:(NSString *)url Reg:(NSString *)Reg;

+ (NSString *)utf8ToUnicode:(NSString *)string;

@end
