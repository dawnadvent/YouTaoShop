//
//  MyMessageProcessor.m
//  Isvtrade
//
//  Created by tianqiao on 12-11-23.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "MyMessageProcessor.h"
#import "ListViewController.h"
#import "LoginUserInfo.h"
#import "DetailViewController.h"
#import "TopAppService.h"
#import "TopIOSClient.h"
#import "TopConstants.h"

@interface MyMessageProcessor()

@property (strong,nonatomic) ListViewController* listViewController;

@end

@implementation MyMessageProcessor


-(void) tradeDetailProcess:(NSDictionary *)params
{
    NSLog(@"tradeDetailProcess -> %@",params);
    [self sso:params];
    
    NSString * tid = [params objectForKey:@"tid"];
    NSString * chatNick = [params objectForKey:PARAMETER_CHATNICK];
    
    NSLog(@"chatNick : %@",chatNick);
    //TODO just for testing
    if(tid==nil){
        tid=@"191620351732890";
    }
    DetailViewController* detailViewController = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    [detailViewController setTitle:@"交易详情"];
    detailViewController.trade = [TradeDO initobject:tid];
    
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    UINavigationController* mainController =(UINavigationController* )[mainWindow rootViewController];
    //起始页正好是交易列表
    [mainController popToRootViewControllerAnimated:NO];
    [mainController pushViewController:detailViewController animated:NO];
    [mainWindow addSubview:[mainController view]]; 

}

-(void) tradeListProcess:(NSDictionary *)params
{
    NSLog(@"tradeListProcess -> %@",params);
    [self sso:params];
    
    NSString * chatNick = [params objectForKey:PARAMETER_CHATNICK];
    
    NSLog(@"chatNick : %@",chatNick);
    
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    UINavigationController* mainController =(UINavigationController* )[mainWindow rootViewController];
    //起始页正好是交易列表
    [mainController popToRootViewControllerAnimated:NO];
    
    if (_listViewController == nil)
    {
        _listViewController = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
        [_listViewController setTitle:@"交易列表"];
        [mainController pushViewController:_listViewController animated:NO];
    }
    //else
        //[mainWindow addSubview:[_listViewController view]];
    
    
    
}

-(void) tradeEntry:(NSDictionary *)params
{
    NSLog(@"tradeEntry -> %@",params);
    [self tradeListProcess:params];
//    [self tradeDetailProcess:params];
    
}


-(void) sso:(NSDictionary *)params
{
    //TODO mock 在此完成授权操作
    NSString * uid = [params objectForKey:@"uid"];
    
    NSString * appkey = [[LoginUserInfo sharedInstance] appkey];
    TopAppService* appservice = [TopAppService getAppServicebyAppKey:appkey];
    TopIOSClient * iosClient = [TopIOSClient getIOSClientByAppKey:appkey];
    
    
    if ([iosClient getAuthByUserId:uid])
    {
        [[LoginUserInfo sharedInstance] registerUserInfo:uid];
    }
    else
    {
        TopAuth *topAuth = [appservice sso:nil eventCallback:nil];
        
        if (topAuth)
        {
            [[LoginUserInfo sharedInstance] registerUserInfo:[topAuth user_id]];
        }
    }
    
    
}
@end
