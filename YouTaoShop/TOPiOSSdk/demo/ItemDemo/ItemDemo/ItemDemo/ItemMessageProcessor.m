//
//  ItemMessageProcessor.m
//  ItemManagementPlugin
//
//  Created by tianqiao on 12-11-22.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "ItemMessageProcessor.h"

@implementation ItemMessageProcessor

@synthesize viewController;

-(void) itemDetailProcess:(NSDictionary *)params
{
    NSString * uid = [params objectForKey:@"uid"];
    
    NSString * iid = [params objectForKey:@"iid"];
    
    NSString * notifyString = [params objectForKey:@"notifyString"];
    

    [viewController showItem];

}

-(void) itemListProcess:(NSDictionary *)params
{
    NSString * uid = [params objectForKey:@"uid"];
    NSString * itemStatus = [params objectForKey:@"itemStatus"];
    
    [viewController showItemList];
    
}

-(void) itemEntry:(NSDictionary *)params
{
    [self itemListProcess:params];
}

@end
