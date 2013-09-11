//
//  ItemAppDelegate.m
//  IsvItem
//
//  Created by tianqiao on 12-11-23.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "ItemAppDelegate.h"
#import "ListViewController.h"
#import "DetailViewController.h"
#import "LoginUserInfo.h"
#import "TopSDKBundle.h"
#import "MyMessageProcessor.h"
#import "JDY_Constants.h"

@implementation ItemAppDelegate
MyMessageProcessor *messageProcessor;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //如果是daily
    [TopToolBar setServer:@[JINDOU_SERVER_URL,TOP_API_URL]];
    //初始化mainController
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainController = [[UINavigationController alloc]init];
    
    //初始化window
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = self.mainController;
    
    //注册事件
    [self registerEvent:launchOptions];
    
    
    //sso
    //if ([[LoginUserInfo sharedInstance] userId] == nil)
    //[self performSelectorInBackground:@selector(auth) withObject:nil];
    
    
    return YES;
}

-(void)registerEvent:(NSDictionary *)launchOptions
{
    //appkey register
    NSString *appkey = [[LoginUserInfo sharedInstance] appkey];
    NSString *appSecret = [[LoginUserInfo sharedInstance] appSecret];
    NSString *callBackUrl = [[LoginUserInfo sharedInstance] callBackUrl];
    
    
    TopIOSClient *topIOSClient = [TopIOSClient registerIOSClient:appkey appSecret:appSecret callbackUrl:callBackUrl needAutoRefreshToken:TRUE];
    
    [topIOSClient setApiEntryUrl:TOP_API_URL];
    [topIOSClient setAuthEntryUrl:TOP_OAUTH_URL];
    [topIOSClient setAuthRefreshEntryUrl:TOP_AUTH_REFRESH_URL];
    [topIOSClient setTqlEntryUrl:TOP_TQL_URL];
    
    TopAppConnector *appConnector = [TopAppConnector registerAppConnector:appkey topclient:topIOSClient];
    [TopAppService registerAppService:appkey  appConnector:appConnector];
    
    
    
    if (messageProcessor == nil)
    {
        messageProcessor = [[[MyMessageProcessor alloc]init]autorelease];
        
        TopEventCallback *itemDetailCallback = [[[TopEventCallback alloc]init] autorelease];
        [itemDetailCallback setTarget:messageProcessor];
        [itemDetailCallback setCallback:@selector(itemDetailProcess:)];
        [itemDetailCallback setNeedMainThreadCallback:YES];
        
        TopEventCallback *itemListCallback = [[[TopEventCallback alloc]init] autorelease];
        [itemListCallback setTarget:messageProcessor];
        [itemListCallback setCallback:@selector(itemListProcess:)];
        [itemListCallback setNeedMainThreadCallback:YES];
        
        TopEventCallback *itemEntryCallback = [[[TopEventCallback alloc]init]autorelease];
        [itemEntryCallback setTarget:messageProcessor];
        [itemEntryCallback setCallback:@selector(itemEntry:)];
        [itemEntryCallback setNeedMainThreadCallback:YES];
        
        [appConnector registerEvent:EVENT_GO_PLUGIN eventProcessor:itemEntryCallback];
        [appConnector registerEvent:EVENT_ITEM_DETAIL eventProcessor:itemDetailCallback];
        [appConnector registerEvent:EVENT_ITEM_LIST eventProcessor:itemListCallback];
    }
    
    //处理被url唤醒的情况
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
    if (url)
    {
        [appConnector receiveMessageFromApp:[url absoluteString]];
    }
    
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *appkey = [[LoginUserInfo sharedInstance] appkey];
    TopAppConnector *appConnector = [TopAppConnector getAppConnectorbyAppKey:appkey];
    
    NSLog(@"url: %@",url);
    
    [appConnector receiveMessageFromApp:[url absoluteString]];
    
    return YES;
}

#pragma mark - 处理自动sso登陆

-(void)auth
{
    NSString *appkey = [[LoginUserInfo sharedInstance] appkey];
    TopAppService * appService = [TopAppService getAppServicebyAppKey:appkey];
    
    
    TopEventCallback *callback = [[TopEventCallback alloc]init];
    [callback setCallback:@selector(authCallback:)];
    [callback setTarget:self];
    [callback setNeedMainThreadCallback:TRUE];
    
    TopAuth *topAuth = [appService sso:nil eventCallback:callback];
    
    if(topAuth)
    {
        if ([NSThread isMainThread])
        {
            [self authCallback:topAuth];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(authCallback:) withObject:topAuth waitUntilDone:TRUE];
        }
    }
    
}

-(void) authCallback:(id)data
{
    if ([data isKindOfClass:[TopAuth class]])
    {
        TopAuth *auth = (TopAuth *)data;
        //把userId注入
        [[LoginUserInfo sharedInstance] registerUserInfo:[auth user_id]];
        //登陆首页
        ListViewController* listViewController = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
        [listViewController setTitle:@"商品列表"];
        
        [[self mainController]pushViewController:listViewController animated:NO];
    }
    else
    {
        NSLog(@"%@",data);
    }
}


@end
