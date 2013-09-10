//
//  TmallChannelViewController.m
//  fanli
//
//  Created by 吴江伟 on 13-8-30.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "TmallChannelViewController.h"
#import "taobaoShopCartViewViewController.h"

@interface TmallChannelViewController ()

@end

@implementation TmallChannelViewController

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
            //天猫
        case 0:
            urlS = @"http://m.tmall.com/";
            [MobClick event:@"tmallClick"];
            break;
            //天猫类目大全
        case 1:
            urlS = @"http://m.tmall.com/tmallCate.htm?";
            [MobClick event:@"mallKinds"];
            break;
            //天猫品牌街
        case 2:
            urlS = @"http://page.m.tmall.com/ppj/ppj_PHONE.html";
            [MobClick event:@"tmall0"];
            break;
            //天猫预售
        case 3:
            urlS = @"http://page.m.tmall.com/yushou/yushou_PHONE.html";
            [MobClick event:@"tmall1"];
            break;
            //天猫特卖
        case 4:
            urlS = @"http://yyz.m.tmall.com/cu/pptm.html?";
            [MobClick event:@"tmallSpecailSell"];
            break;
        
            //天猫今日大牌
        case 5:
            urlS = @"http://yyz.m.tmall.com/cu/JRZDPwuxian.html?";
            [MobClick event:@"tmallZuidapai"];
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
