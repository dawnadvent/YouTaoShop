//
//  MoreViewController.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-24.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "MoreViewController.h"
#import "taobaoData.h"
#import "MailViewController.h"
#import "SettingViewController.h"
#import "followOrderViewController.h"
#import "normalQaViewController.h"
#import "customFollowShopCart.h"
#import "GetFanliViewController.h"

#import "AppDelegate.h"

static CGFloat userFanli = 0;

@interface MoreViewController ()
{
    IBOutlet UILabel *fanliDesLable;
}

@end

@implementation MoreViewController

+ (CGFloat)getUserFanliTotal
{
    return userFanli;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrderForFanli:) name:kUserFanliCount object:nil];
    }
    return self;
}

- (void)newOrderForFanli:(NSNotification *)notification
{

    NSLog(@"newOrderForFanli num %@", notification.object);
    
    if (!notification.object) {
        fanliDesLable.text = nil;
        return;
    }
    
    NSArray *array = notification.object; 
    
    taobaokeCalculateObject *caiculate = [[taobaokeCalculateObject alloc] init];
    [caiculate recordTotalFanliWithArray:array];
    caiculate.delegate = self;
    //fanliDesLable.text = [NSString stringWithFormat:@"约%d次交易返利", num.intValue];
}

static NSString *shareNote = @"wjwSharedNoteKey";

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int shareFlag = [[NSUserDefaults standardUserDefaults] integerForKey:shareNote];
    if (!buttonIndex) {
        //share
        shareFlag = 103;
        [[NSUserDefaults standardUserDefaults] setInteger:shareFlag forKey:shareNote];
        [self shareMe:nil];
        [MobClick event:@"sharedNoteOk"];
    }else{
        if (shareFlag == 100) {
            shareFlag = 1;
        }else
            shareFlag++;
        [[NSUserDefaults standardUserDefaults] setInteger:shareFlag forKey:shareNote];
        
        MailViewController *fanliViewControl = [[[MailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        fanliViewControl.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"getFanli"];
        [self.navigationController pushViewController:fanliViewControl animated:YES];
        [MobClick event:@"sharedNoteNo"];
    }
}

- (IBAction)seeRebateNote:(id)sender {
    GetFanliViewController *vc = [[[GetFanliViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)getFanli:(id)sender {
    
    if ([customFollowShopCart getOrderFanliInfo]) {
        int shareFlag = [[NSUserDefaults standardUserDefaults] integerForKey:shareNote];
        if (!(shareFlag % 4) && shareFlag <= 100) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享100%拿额外返利" message:@"亲，支持我们吧，把您的购物省钱绝招分享给小伙伴们" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"残忍的拒绝", nil];
            [alert show];
            [alert release];
            [MobClick event:@"sharedNote"];
            return;
        }else if(shareFlag > 100)
        {
            shareFlag--;
            [[NSUserDefaults standardUserDefaults] setInteger:shareFlag forKey:shareNote];
        }else{
            shareFlag++;
            [[NSUserDefaults standardUserDefaults] setInteger:shareFlag forKey:shareNote];
        }
    }
    
    MailViewController *fanliViewControl = [[[MailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    fanliViewControl.hidesBottomBarWhenPushed = YES;
    [MobClick event:@"getFanli"];
    [self.navigationController pushViewController:fanliViewControl animated:YES];
}

- (IBAction)followOrder:(id)sender {
    followOrderViewController *followVC = [[[followOrderViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    followVC.hidesBottomBarWhenPushed = YES;
    [MobClick event:@"noteFollowOrder"];
    [self.navigationController pushViewController:followVC animated:YES];
    
}

- (IBAction)settingTap:(id)sender {
    SettingViewController *setVC = [[[SettingViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    setVC.hidesBottomBarWhenPushed = YES;
    [MobClick event:@"setting"];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (IBAction)rankTap:(id)sender {
    [MobClick event:@"rankMe"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",667902169]]];
}

- (IBAction)QATap:(id)sender {
    normalQaViewController *followVC = [[[normalQaViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    followVC.hidesBottomBarWhenPushed = YES;
    [MobClick event:@"seeQA"];
    [self.navigationController pushViewController:followVC animated:YES];
}

- (void)TotalFanliResult:(float)fanliValue
{
    if (!fanliValue) {
        fanliDesLable.text = @"无返利/网络错误";
        return;
    }
    userFanli = fanliValue;
    fanliDesLable.text = [NSString stringWithFormat:@"返利￥%.1f", fanliValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:UIColorFromRGB(0xECF0F1)];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSArray *array = [customFollowShopCart getFanliInfoToRefreshUI];
    NSLog(@"more num %@", array);
    if (!array) {
        fanliDesLable.text = nil;
        return;
    }
    
    taobaokeCalculateObject *caiculate = [[taobaokeCalculateObject alloc] init];
    [caiculate recordTotalFanliWithArray:array];
    caiculate.delegate = self;
}

- (void)dealloc {
    [fanliDesLable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [fanliDesLable release];
    fanliDesLable = nil;
    [super viewDidUnload];
}

#pragma mark - shared to sina weixin qq and other

- (IBAction)shareMe:(id)sender {

    [MobClick event:@"share"];
    
    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
    UMSocialIconActionSheet *iconActionSheet = [[UMSocialControllerService defaultControllerService] getSocialIconActionSheetInController:self];
    [iconActionSheet showInView:self.view];
    
    [UMSocialData defaultData].shareImage = [UIImage imageNamed:@"icon"];
    [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"Hi 亲们，我在使用一款IOS软件：淘宝返利吧 \n他可以淘宝购物100%返利，秒杀其他一切返利App么，  我已经%@元啦，   亲们还在等什么呢，下载链接 https://itunes.apple.com/us/app/quan-fan-li-qing-gou-wu/id667902169?ls=1&mt=8", fanliDesLable.text];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeMusic url:@"https://itunes.apple.com/us/app/quan-fan-li-qing-gou-wu/id667902169?ls=1&mt=8"];
    [UMSocialData defaultData].urlResource = urlResource;
    
    //设置实现回调方法的对象，可以将[UMSocialControllerService defaultControllerService]替换成自己对应的`UMSocialControllerService`对象
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    
    //如果当前的UIViewController在一个tabBarController中的话，应该改为[iconActionSheet showInView:self.tabBarController.view];
    
    [[AppDelegate getLeveyTabBarControl] hidesTabBar:YES animated:YES];
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    [[AppDelegate getLeveyTabBarControl] hidesTabBar:NO animated:YES];
}

//实现回调方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    int shareFlag = [[NSUserDefaults standardUserDefaults] integerForKey:shareNote];
    int shareSucceed = [[NSUserDefaults standardUserDefaults] integerForKey:userSharedSucceedKey];
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        shareFlag = 110;
        shareSucceed++;
        [[NSUserDefaults standardUserDefaults] setInteger:shareSucceed forKey:userSharedSucceedKey];
        [MobClick event:@"sharedSucceed"];
    }else{
        shareFlag = 106;
        [MobClick event:@"sharedFailed"];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:shareFlag forKey:shareNote];
    
    [[AppDelegate getLeveyTabBarControl] hidesTabBar:NO animated:YES];
}

@end
