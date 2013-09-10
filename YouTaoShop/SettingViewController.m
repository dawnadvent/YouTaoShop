//
//  SettingViewController.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-17.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"

#define kGotoProductDetailPage @"GotoProductDetailPage"
#define kGetTaobaoShopcartFanli @"GetTaobaoShopcartFanli"

BOOL isGotoProductDetailPage = NO;
BOOL isGetTaobaoShopcartFanli = YES;

@interface SettingViewController ()

@end

@implementation SettingViewController
{
    
    IBOutlet UISwitch *isGetFanliInShopcart;
    IBOutlet UISwitch *isGotoDetail;
}

+ (BOOL)isGotoProductDetailPage
{
    return isGotoProductDetailPage;
}

+ (BOOL)isGetTaobaoShopcartFanli
{
    return isGetTaobaoShopcartFanli;
}

- (IBAction)shopCartValueCange:(UISwitch *)sender {
    if ([sender isOn]) {
        isGetTaobaoShopcartFanli = YES;
    }else{
        isGetTaobaoShopcartFanli = NO;
    }
    NSLog(@"shopCartValueCange %d", isGetTaobaoShopcartFanli);
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:[NSNumber numberWithBool:isGetTaobaoShopcartFanli] forKey:kGetTaobaoShopcartFanli];
}

- (IBAction)switchValueChaneg:(UISwitch *)sender {
    if ([sender isOn]) {
        isGotoProductDetailPage = YES;
    }else{
        isGotoProductDetailPage = NO;
    }
    NSLog(@"isGotoProductDetailPage %d", isGotoProductDetailPage);
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:[NSNumber numberWithBool:isGotoProductDetailPage] forKey:kGotoProductDetailPage];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:UIColorFromRGB(0xECF0F1)];
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *gotoDetail = [accountDefaults objectForKey:kGotoProductDetailPage];
    NSNumber *isGetShopCart = [accountDefaults objectForKey:kGetTaobaoShopcartFanli];
    if (gotoDetail) {
        isGotoProductDetailPage = gotoDetail.boolValue;
        [isGotoDetail setOn:gotoDetail.boolValue];
    }
    if (isGetShopCart) {
        isGetTaobaoShopcartFanli = isGetShopCart.boolValue;
        [isGetFanliInShopcart setOn:isGetShopCart.boolValue];
    }
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)evaluateMe:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"667902169"]]];
}

- (IBAction)aboutMe:(id)sender {
    AboutViewController *aboutVC = [[[AboutViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    aboutVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (IBAction)clearCookie:(id)sender {
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    NSArray* baiduCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://m.taobao.com"]];
    for (NSHTTPCookie* cookie in baiduCookies) {
        NSLog(@"cookie %@", cookie);
        [cookies deleteCookie:cookie];
    }
    
    [[RFToast sharedInstance] showToast:@"清除浏览器信息成功" inView:self.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [isGotoDetail release];
    [isGetFanliInShopcart release];
    [super dealloc];
}
- (void)viewDidUnload {
    [isGotoDetail release];
    isGotoDetail = nil;
    [isGetFanliInShopcart release];
    isGetFanliInShopcart = nil;
    [super viewDidUnload];
}
@end
