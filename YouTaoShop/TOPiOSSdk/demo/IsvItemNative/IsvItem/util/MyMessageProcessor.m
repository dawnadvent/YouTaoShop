//
//  MyMessageProcessor.m
//  IsvItem
//
//  Created by tianqiao on 12-11-23.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "MyMessageProcessor.h"
#import "ListViewController.h"
#import "LoginUserInfo.h"
#import "DetailViewController.h"

@interface MyMessageProcessor()

@property (strong,nonatomic) ListViewController* listViewController;

@end

@implementation MyMessageProcessor
-(void) itemDetailProcess:(NSDictionary *)params
{
    NSLog(@"itemDetailProcess -> %@",params);
    
    NSString * iid = [params objectForKey:@"iid"];
    NSString * uid = [params objectForKey:@"uid"];
    
    //把userId注入
    [[LoginUserInfo sharedInstance] registerUserInfo:uid];
    
    //TODO just for testing
    if(iid==nil){
        iid=@"19980472624";
    }
    DetailViewController* detailViewController = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    [detailViewController setTitle:@"商品详情"];
    detailViewController.item = [ItemDO initObject:iid];
    
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    UINavigationController* mainController =(UINavigationController* )[mainWindow rootViewController];
    //起始页正好是商品列表
    [mainController popToRootViewControllerAnimated:NO];
    [mainController pushViewController:detailViewController animated:NO];
    
    
    
    
}

-(void) itemListProcess:(NSDictionary *)params
{
    NSLog(@"itemListProcess -> %@",params);
    
    NSString * uid = [params objectForKey:@"uid"];
    
    //把userId注入
    [[LoginUserInfo sharedInstance] registerUserInfo:uid];
    
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    UINavigationController* mainController =(UINavigationController* )[mainWindow rootViewController];
    //起始页正好是商品列表
    [mainController popToRootViewControllerAnimated:NO];
    
    
    //[mainWindow addSubview:[mainController view]];
    
    if (_listViewController == nil)
    {
        _listViewController = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
        [_listViewController setTitle:@"商品列表"];
        
        [mainController pushViewController:_listViewController animated:NO];
    }
    
}

-(void) itemEntry:(NSDictionary *)params
{
    NSLog(@"itemEntry -> %@",params);
    
    NSString * uid = [params objectForKey:@"uid"];
    
    //把userId注入
    [[LoginUserInfo sharedInstance] registerUserInfo:uid];
    
    [self itemListProcess:params];
//    [self itemDetailProcess:params];
    
}
@end
