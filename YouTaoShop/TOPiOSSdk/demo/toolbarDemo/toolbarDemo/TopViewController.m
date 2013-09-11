//
//  TopViewController.m
//  toolbarDemo
//
//  Created by lihao on 12-12-7.
//  Copyright (c) 2012年 lihao. All rights reserved.
//

#import "TopViewController.h"
#import "TopToolBar.h"

@interface TopViewController ()

@property(retain) TopToolBar* bar;

@end

@implementation TopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //这个是绑定代码
    if(self.bar == nil){
        self.bar = [TopToolBar bindBaseView:self.view withApp:@"4272" tmallStyle:YES unreadCountFromUser:@""];
    }
    [_bar bringToFront];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)tmallStyleBtnClick:(id)sender {
    self.bar = [TopToolBar bindBaseView:self.view withApp:@"4272" tmallStyle:YES unreadCountFromUser:@""];
    [self.bar bringToFront];
}
- (IBAction)taobaoStyleBtnClick:(id)sender {
    self.bar = [TopToolBar bindBaseView:self.view withApp:@"4272" tmallStyle:NO unreadCountFromUser:@""];
    [self.bar bringToFront];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidUnload{
    [_bar release];
    _bar = nil;
}

@end
