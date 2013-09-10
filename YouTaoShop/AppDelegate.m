//
//  AppDelegate.m
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-28.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "AppDelegate.h"
#import "taobaoData.h"
#import "SDURLCache.h"

#import "MainViewController.h"
#import "TaobaoViewController.h"
#import "SearchViewController.h"
#import "MyFavViewController.h"
#import "MoreViewController.h"

#import "UMSocial.h"


#define kWindowHeight  [[UIApplication sharedApplication] keyWindow].bounds.size.height

LeveyTabBarController *gobalLeveyTabBarC = nil;

@implementation AppDelegate
{
    //fav
    MyFavViewController *fourthVC;
}

@synthesize navigationController;

+ (NSString *)cachesDirectoryPath
// Returns the path to the caches directory.  This is a class method because it's
// used by +applicationStartup.
{
    NSString *      result;
    NSArray *       paths;
    
    result = nil;
    paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ( (paths != nil) && ([paths count] != 0) ) {
        assert([[paths objectAtIndex:0] isKindOfClass:[NSString class]]);
        result = [paths objectAtIndex:0];
    }
    return result;
}

+ (NSInteger)OSVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

+ (LeveyTabBarController *)getLeveyTabBarControl
{
    return gobalLeveyTabBarC;
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
                                                         diskCapacity:1024*1024*5 // 5MB disk cache
                                                             diskPath:[SDURLCache defaultCachePath]];
    
    MainViewController *firstVC = [[[MainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	TaobaoViewController *secondVC = [[[TaobaoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	SearchViewController *thirdVC = [[[SearchViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	fourthVC = [[[MyFavViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    fourthVC.isHomeFav = YES;
    MoreViewController *fifth = [[[MoreViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
	UINavigationController *nc0 = [[[UINavigationController alloc] initWithRootViewController:firstVC] autorelease];
	nc0.delegate = self;
    UINavigationController *nc1 = [[[UINavigationController alloc] initWithRootViewController:secondVC] autorelease];
	nc1.delegate = self;
    UINavigationController *nc2 = [[[UINavigationController alloc] initWithRootViewController:thirdVC] autorelease];
	nc2.delegate = self;
    UINavigationController *nc3 = [[[UINavigationController alloc] initWithRootViewController:fourthVC] autorelease];
	nc3.delegate = self;
    UINavigationController *nc4 = [[[UINavigationController alloc] initWithRootViewController:fifth] autorelease];
	nc4.delegate = self;
	NSArray *ctrlArr = [NSArray arrayWithObjects:nc0,nc1,nc2,nc3,nc4,nil];
    
	NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageNamed:@"homemenu0.png"] forKey:@"Default"];
	[imgDic setObject:[UIImage imageNamed:@"homemenu0.png"] forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageNamed:@"homemenu0_selected.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:@"homemenu1.png"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:@"homemenu1.png"] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:@"homemenu1_selected.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:@"homemenu2.png"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:@"homemenu2.png"] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:@"homemenu2_selected.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageNamed:@"homemenu3.png"] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:@"homemenu3.png"] forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageNamed:@"homemenu3_selected.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic5 setObject:[UIImage imageNamed:@"moneyHome.png"] forKey:@"Default"];
	[imgDic5 setObject:[UIImage imageNamed:@"moneyHome.png"] forKey:@"Highlighted"];
	[imgDic5 setObject:[UIImage imageNamed:@"money.png"] forKey:@"Seleted"];
	
	NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic4,imgDic5,nil];
	
	leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
    gobalLeveyTabBarC = leveyTabBarController;
    leveyTabBarController.delegate = self;
	[leveyTabBarController.tabBar setBackgroundColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:0.8]];
	[leveyTabBarController setTabBarTransparent:YES];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[self.window addSubview:leveyTabBarController.view];
    
    //change frame
    //abandon
    firstVC.view.frame = CGRectMake(0, 0, 320, kWindowHeight - 20 - 40);
    secondVC.view.frame = CGRectMake(0, 0, 320, kWindowHeight - 50 - 40);
    thirdVC.view.frame = CGRectMake(0, 0, 320, kWindowHeight - 50 - 40);
    fourthVC.view.frame = CGRectMake(0, 0, 320, kWindowHeight - 50 - 40);
    fifth.view.frame = CGRectMake(0, 0, 320, kWindowHeight - 50 - 40);
    [self.window makeKeyAndVisible];

    //taobao
    TopIOSClient *topIOSClient = [TopIOSClient registerIOSClient:kTaobaoKey appSecret:kTaobaoSecret callbackUrl:kTaobaoCallBack needAutoRefreshToken:YES];
    [TopAppConnector registerAppConnector:kTaobaoKey topclient:topIOSClient];
    

    //if (!SIMULATOR) {
    if (1) {
        NSLog(@"not simulator, start UMeng statistic");
        [MobClick startWithAppkey:UMENG_APP_KEY reportPolicy:SEND_INTERVAL channelId:nil];
        [MobClick setCrashReportEnabled:YES];
        [MobClick checkUpdate];
        
        //获取UMeng上的所有配置参数
        [MobClick updateOnlineConfig];
    }
    
    //weixin
    [WXApi registerApp:@"wx74090dc1f68d7176"];
    
    return YES;
}

- (BOOL)isThisViewControlNeedHides:(UIViewController *)viewControl
{
    if (viewControl == fourthVC) {
        return NO;
    }
    
    return NO;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //	if ([viewController isKindOfClass:[SecondViewController class]])
    //	{
    //        [leveyTabBarController hidesTabBar:NO animated:YES];
    //	}
    
    if ([self isThisViewControlNeedHides:viewController] || viewController.hidesBottomBarWhenPushed)
    {
        [leveyTabBarController hidesTabBar:YES animated:YES];
    }
    else
    {
        [leveyTabBarController hidesTabBar:NO animated:YES];
    }
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    TopIOSClient *topClient = [TopIOSClient getIOSClientByAppKey:kTaobaoKey];
    [topClient authCallback:[url absoluteString]];
    
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
    [MobClick updateOnlineConfig];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UMSocialSnsService  applicationDidBecomeActive];
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    return;
}

@end
