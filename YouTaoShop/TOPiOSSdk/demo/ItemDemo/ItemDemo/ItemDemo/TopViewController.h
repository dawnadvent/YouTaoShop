//
//  TopViewController.h
//  ItemDemo
//
//  Created by lihao on 12-11-23.
//  Copyright (c) 2012年 lihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) UIWebView *webview;

-(void) showItem;
-(void) showItemList;
-(void) resetToolbar;

@end
