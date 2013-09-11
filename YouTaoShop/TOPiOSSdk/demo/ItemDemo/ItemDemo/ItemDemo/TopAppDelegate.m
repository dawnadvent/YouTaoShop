//
//  TopAppDelegate.m
//  ItemDemo
//
//  Created by lihao on 12-11-23.
//  Copyright (c) 2012年 lihao. All rights reserved.
//

#import "TopAppDelegate.h"
#import "TopappConnector.h"
#import "TopViewController.h"
#import "TopAppService.h"
#import "ItemMessageProcessor.h"
#import "TopAppEntity.h"
#import "TopAppPlugin.h"
#import "TopAppEvent.h"


@implementation TopAppDelegate

ItemMessageProcessor *itemMessageProcessor;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[TopViewController alloc] initWithNibName:@"TopViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[TopViewController alloc] initWithNibName:@"TopViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //开始注册处理事件
    TopIOSClient *topIOSClient = [TopIOSClient registerIOSClient:@"21279751"  appSecret:@"eb3f3ddb58206f07d096540b5c9f0edb" callbackUrl:@"jdyAuthBack://" needAutoRefreshToken:TRUE];
    
    
    TopAppConnector *appConnector = [TopAppConnector registerAppConnector:@"21279751" topclient:topIOSClient];
    
    [TopAppService registerAppService:@"21279751" appConnector:appConnector];
    
    //mock others
    //mock others
    TopAppEntity* entry = [[TopAppEntity alloc]init];
    entry.appkey = @"21283190";
    entry.callbackUrl = @"jdyTradeBack://";
    [appConnector.appInfoPool setValue:entry forKey:entry.appkey];
    entry = [[TopAppEntity alloc]init];
    entry.appkey = @"21279751";
    entry.callbackUrl = @"jdyAuthBack://";
    [appConnector.appInfoPool setValue:entry forKey:entry.appkey];
    
    if (itemMessageProcessor == nil)
    {
        itemMessageProcessor = [[ItemMessageProcessor alloc]init];
        [itemMessageProcessor setViewController:self.viewController];
        
        TopEventCallback *itemDetailCallback = [[TopEventCallback alloc]init];
        [itemDetailCallback setTarget:itemMessageProcessor];
        [itemDetailCallback setNeedMainThreadCallback:YES];
        [itemDetailCallback setCallback:@selector(itemDetailProcess:)];
        
        TopEventCallback *itemListCallback = [[TopEventCallback alloc]init];
        [itemListCallback setTarget:itemMessageProcessor];
        [itemListCallback setNeedMainThreadCallback:YES];
        [itemListCallback setCallback:@selector(itemListProcess:)];
        
        TopEventCallback *itemEntryCallback = [[TopEventCallback alloc]init];
        [itemEntryCallback setTarget:itemMessageProcessor];
        [itemEntryCallback setNeedMainThreadCallback:YES];
        [itemEntryCallback setCallback:@selector(itemEntry:)];
        
        [appConnector registerEvent:EVENT_GO_PLUGIN eventProcessor:itemEntryCallback];
        [appConnector registerEvent:EVENT_ITEM_DETAIL eventProcessor:itemDetailCallback];
        [appConnector registerEvent:EVENT_ITEM_LIST eventProcessor:itemListCallback];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    TopAppService *appService = [TopAppService getAppServicebyAppKey:@"21279751"];
    TopAppConnector *appConnector = [TopAppConnector getAppConnectorbyAppKey:@"21279751"];
    
    
    if([@"jsEvent" isEqualToString:[url host]]){
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        NSArray *listItems = [[url query] componentsSeparatedByString:@"&"];
        for(id item in listItems)
        {
            NSArray *kv = [(NSString *)item componentsSeparatedByString:@"="];
            [params setObject:kv[1] forKey:kv[0]];
        }
        if ([@"/gotoPlatform" isEqualToString:[url path]]) {
            
            NSLog(@"will go to %@",[params objectForKey:@"to"]);
            [appService backToSellserPlatform:[params objectForKey:@"to"] params:nil];
            [self.viewController resetToolbar];
        }else if ([@"/gotoPlugin" isEqualToString:[url path]]) {
            [appConnector sendRequestToAppWithAsynMode:[params objectForKey:@"to"] event:EVENT_GO_PLUGIN params:nil eventCallback:nil];
        }
        return NO;
    }
    
    //TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:@"21102355"];
    
    NSLog(@"url: %@",url);
    
    [appConnector receiveMessageFromApp:[url absoluteString]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
