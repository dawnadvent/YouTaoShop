//
//  AppDelegate.h
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-28.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBarController.h"

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate, LeveyTabBarControllerDelegate, UINavigationControllerDelegate>
{
    LeveyTabBarController *leveyTabBarController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIViewController *viewController;


+ (NSInteger)OSVersion;
+ (LeveyTabBarController *)getLeveyTabBarControl;


@end
