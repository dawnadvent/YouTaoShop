//
//  TopLastUsedPluginManager.h
//  TOPIOSSdk
//
//  Created by emerson_li on 12-12-27.
//  Copyright (c) 2012年 tmall.com. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TopLastUsedPluginManagerNotification @"TopLastUsedPluginManagerNotification"
#define LAST_PLGUIN_USE_DATA(data) [NSString stringWithFormat:@"TopLastUsedPluginManagerData%@",data]
#define LAST_PLGUIN_USE_STATUS(data) [NSString stringWithFormat:@"TopLastUsedPluginManagerStatus%@",data]

@interface TopLastUsedPluginManager : NSObject


-(NSArray*) getLastUsedPlugins:(NSString*) userId byApp:(NSString*) appkey;

-(void) clean:(NSString*) userId;

-(void) setNeedReflesh:(NSString*) userId;

+(TopLastUsedPluginManager*) getSharedManager;

+(void)setServer:(NSString*)server;

+(NSString*)getServer;

@end
