//
//  ItemMessageProcessor.h
//  ItemManagementPlugin
//
//  Created by tianqiao on 12-11-22.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopViewController.h"

@interface ItemMessageProcessor : NSObject

@property (strong, nonatomic) TopViewController *viewController;

-(void) itemDetailProcess:(NSDictionary *)params;

-(void) itemListProcess:(NSDictionary *)params;

-(void) itemEntry:(NSDictionary *)params;

@end
