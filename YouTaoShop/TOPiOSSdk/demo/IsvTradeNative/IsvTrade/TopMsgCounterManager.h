//
//  TopMsgCounterManager.h
//  TOPIOSSdk
//
//  Created by emerson_li on 12-12-27.
//  Copyright (c) 2012年 tmall.com. All rights reserved.
//

#define JDYMsgEntryManagerDidCounterChangeNotification @"JDYMsgEntryManagerDidCounterChangeNotification"
#import <Foundation/Foundation.h>

@interface TopMsgCounterManager : NSObject

-(NSArray*) getUnReadNum:(NSString*) userId byApp:(NSString*) appkey;

-(void) pullRemoteReadNum;

+(TopMsgCounterManager*) getSharedManager;

+(void)setServer:(NSString*)server;

+(void)alwaysFromPasteboard;

@end
