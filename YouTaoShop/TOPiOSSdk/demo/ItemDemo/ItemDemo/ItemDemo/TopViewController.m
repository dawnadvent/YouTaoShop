//
//  TopViewController.m
//  ItemDemo
//
//  Created by lihao on 12-11-23.
//  Copyright (c) 2012年 lihao. All rights reserved.
//

#import "TopViewController.h"
#import "TMSToolBar.h"

@interface TopViewController ()

@property(strong, nonatomic) TMSToolBar *toolbar;
@property(strong, nonatomic) NSString * cmd;
@property bool loaded;

@end

@implementation TopViewController

- (void)viewDidLoad
{
    self.webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSURL *url =[NSURL URLWithString:@"http://jindoucloud.aliapp.com/item.html"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    self.webview.delegate=self;
    self.scrollview.delegate = self;
    self.webview.scrollView.delegate=self;
    [super viewDidLoad];
    TMSToolBar *view = [[TMSToolBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0.0f,150.0f, self.view.frame.size.height) withApp:@"jdyAuthBack"];
    self.toolbar = view;
    self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width + 150, self.view.frame.size.height);
    [self.scrollview addSubview:self.webview];
    [self.scrollview addSubview:view];
    self.scrollview.bounces=NO;
    self.scrollview.alwaysBounceVertical=NO;
    self.scrollview.showsHorizontalScrollIndicator=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[self.toolbar tmsScrollViewDidScroll:self.scrollview];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[self.toolbar tmsScrollViewDidEndDragging:self.scrollview];
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.loaded = YES;
    if(self.cmd){
        [self.webview stringByEvaluatingJavaScriptFromString:self.cmd];
    }
    
}

-(void) showItem{
    
    if(self.loaded){
        [self.webview stringByEvaluatingJavaScriptFromString:@"$.mobile.changePage('#page2');"];
    }else{
        self.cmd = @"$.mobile.changePage('#page2');";
    }
    
    [self resetToolbar];
}
-(void) showItemList{
    if(self.loaded){
        [self.webview stringByEvaluatingJavaScriptFromString:@"$.mobile.changePage('#page1');"];
    }else{
        self.cmd = @"$.mobile.changePage('#page1');";
    }
    
    [self resetToolbar];
}

-(void) resetToolbar{
    [self.scrollview setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    self.scrollview.contentOffset = CGPointMake(0, 0);
}

@end
