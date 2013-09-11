//
//  TopViewController.m
//  brigedemo
//
//  Created by lihao on 12-12-7.
//  Copyright (c) 2012年 lihao. All rights reserved.
//

#import "TopViewController.h"
#import "TopBridgeWebview.h"


@interface TopViewController ()

@end

@implementation TopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[super viewDidLoad];
//    NSURL *url =[NSURL URLWithString:@"http://jindoucloud.aliapp.com/bridge/test.html"];
    NSURL *url =[NSURL URLWithString:@"http://jindoucloud.aliapp.com/bridge/test.html"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_bridgeview loadRequest:request];
    
    //注册两个方法
    [TopBridgeWebview addObserver:self selector:@selector(test:resp:) oncall:@"sayhello"];
    [TopBridgeWebview addObserver:self selector:@selector(test1:resp:) oncall:@"timeout"];
    
    //这个非常重要
    [_bridgeview bridgeEnable:YES];
    
    
    
    //一些不需要ISV做的事情，container自己会做的，这边demo先mock
    [self mockContainer];
}

-(void)mockAppInfo{
    
}

#pragma -mark 用户自定义方法

-(void)test:(NSDictionary*) data resp:(void(^)(NSString* resp))resp_block{
    resp_block(@"{name:'zhudi',id:1234}");
}

-(void)test1:(NSDictionary*) data resp:(void(^)(NSString* resp))resp_block{
    //一直不调用resp_block给响应，直到超时
}

#pragma -mark APPKEY H5 容器自动会做的一些事情，这边先mock一下
-(void) mockContainer{
    [_bridgeview.subParameters setValue:@"4272" forKey:@"appkey"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_bridgeview release];
    [super dealloc];
}
@end
