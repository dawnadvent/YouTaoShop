//
//  BannerImageView.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-24.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "BannerImageView.h"
#import "taobaoShopCartViewViewController.h"

@implementation BannerImageView

- (UIViewController *)viewControl
{
    UIResponder *responder = [self.superview nextResponder];
    
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
    }
    
    return (UIViewController *)responder;
}

- (void)tapGes:(UITapGestureRecognizer *)tapGes
{
    if (_isLocalJump) {
        //废弃
        
        //return;
    }
    
    taobaoShopCartViewViewController *webContentViewControl = nil;
    webContentViewControl = [[[taobaoShopCartViewViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    NSURL *url2 = [NSURL URLWithString:_clickUrl];
    webContentViewControl.hidesBottomBarWhenPushed = YES;
    [_rootViewControl.navigationController pushViewController:webContentViewControl animated:YES];
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
    if (self.tag == 1) {
        [MobClick event:@"bannerClick"];
    }else{
        [MobClick event:@"selectMyShop"];
    }
    
    [webContentViewControl.webView loadRequest:request];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
        [self addGestureRecognizer:ges];
        [ges release];
    }
    return self;
}

- (void)dealloc{
    //SAFE_RELEASE(_rootViewControl);
    SAFE_RELEASE(_clickUrl);
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
