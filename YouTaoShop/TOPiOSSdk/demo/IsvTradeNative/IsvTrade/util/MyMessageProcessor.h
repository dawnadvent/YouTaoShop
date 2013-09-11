//
//  MyMessageProcessor.h
//  Isvtrade
//
//  Created by tianqiao on 12-11-23.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMessageProcessor : NSObject
-(void) tradeDetailProcess:(NSDictionary *)params;

-(void) tradeListProcess:(NSDictionary *)params;

-(void) tradeEntry:(NSDictionary *)params;
@end
