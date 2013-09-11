//
//  MyMessageProcessor.h
//  IsvItem
//
//  Created by tianqiao on 12-11-23.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMessageProcessor : NSObject
-(void) itemDetailProcess:(NSDictionary *)params;

-(void) itemListProcess:(NSDictionary *)params;

-(void) itemEntry:(NSDictionary *)params;
@end
