//
//  taobaoChannelViewController.m
//  fanli
//
//  Created by 吴江伟 on 13-8-30.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "taobaoChannelViewController.h"
#import "taobaoShopCartViewViewController.h"

@interface taobaoChannelViewController ()

@end

@implementation taobaoChannelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:UIColorFromRGB(0xECF0F1)];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)FirstButtonClick:(UIButton *)sender {
    
    taobaoShopCartViewViewController *webContentViewControl = nil;
    webContentViewControl = [[[taobaoShopCartViewViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    NSString *urlS = nil;
    NSURL *url2 = nil;
    
    switch (sender.tag) {
            //淘宝
        case 0:
            urlS = @"http://m.taobao.com/";
            [MobClick event:@"taobaoClick"];
            break;
            //爱淘宝
        case 1:
            urlS = @"http://ai.m.taobao.com";
            [MobClick event:@"taobao0"];
            break;
            //淘宝逛街
        case 2:
            urlS = @"http://r.m.taobao.com/m3?p=mm_43457538_4062176_13214959&c=1563";
            [MobClick event:@"taobaoShopping"];
            break;
            //拇指斗价
        case 3:
            urlS = @"http://h5.m.taobao.com/mz/index.htm";
            [MobClick event:@"muzhidoujia"];
            break;
            //淘宝类目大全
        case 4:
            urlS = @"http://m.taobao.com/channel/act/sale/quanbuleimu.html?";
            [MobClick event:@"taoKinds"];
            break;
            
        case 1001:
            //收藏的宝贝
            urlS = @"http://h5.m.taobao.com/fav/index.htm?!goods/queryColGood-1";
            [MobClick event:@"taobaofav"];
            break;
        case 1002:
            //订单信息
            urlS = @"http://h5.m.taobao.com/my/index.htm?#!orderList-4/-Z1";
            [MobClick event:@"taobaoorder"];
            break;
        case 1003:
            //查物流
            urlS = @"http://h5.m.taobao.com/my/index.htm#!orderList-5/-Z1";
            [MobClick event:@"taobaowuliu"];
            break;
            
        default:
            urlS = @"http://m.taobao.com/";
            break;
    }
    
    url2 = [NSURL URLWithString:urlS];
    webContentViewControl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webContentViewControl animated:YES];
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
    
    [webContentViewControl.webView loadRequest:request];
}


@end
