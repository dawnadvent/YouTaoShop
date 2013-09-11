//
//  TopApiCallUtil.h
//  TradePluginDemo
//
//  Created by tianqiao on 12-11-14.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TopApiCallUtil : NSObject
+(NSString *)runTql:(NSString *)tql;
+(NSDictionary *) getJsonObject:(NSString *) tql;
+(NSDictionary *) getJsonObject:(NSString *)tql method:(NSString *) method;
+(NSString *)getError:(NSDictionary *)result;
@end
