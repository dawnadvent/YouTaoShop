//
//  YoutaoMainViewController.m
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-28.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "MainViewController.h"
#import "taobaoData.h"
#import "taobaoShopCartViewViewController.h"
#import "SearchViewController.h"
#import "BannerImageView.h"
#import "PcShoppingViewController.h"
#import "customTabBarItem.h"

#import "DayRecommendViewController.h"

#import "TmallChannelViewController.h"
#import "taobaoChannelViewController.h"

#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"

#define kNEW_SHOW_PIC    @"newShowPic0"
#define kShop_cart_Note    @"shopcartNote0"

#define BANNER_PLIST_FILE   @"banner.plist"

@interface MainViewController ()
{
    UITabBar *tabMenuBar;
    
    customTabBarItem *fanliTabBar;
    
    IBOutlet UIImageView *shopCartNote;
    uint bannerArrayCount;
    UIPageControl *scrollPage;
    
    uint currentTabIndex;
    UIImageView *itemBg;
}

@end

@implementation MainViewController

#pragma mark - get confige file
- (NSString *)getContentWithName:(NSString *)fileName
{
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths1 objectAtIndex:0];
    [documentsDirectory stringByAppendingPathComponent:fileName];
    return [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:fileName];
}

#pragma mark - taobao callback

- (void)taobaoCallback:(id)aaa
{
    NSLog(@"aaa %@", aaa);
}

- (void)bannerTimer:(NSTimer *)timer
{
    CGPoint bannerPoint = BannerScrollView.contentOffset;
    if (bannerPoint.x == (bannerArrayCount-1)*320) {
        bannerPoint.x = 0;
    }else{
        bannerPoint.x = bannerPoint.x + 320;
    }
    if (bannerArrayCount-1 < bannerPoint.x/320) {
        scrollPage.currentPage = 0;
    }else
        scrollPage.currentPage = bannerPoint.x/320;
    BannerScrollView.contentOffset = bannerPoint;
}

- (void)startBannerTimer
{
    [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(bannerTimer:) userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (bannerArrayCount-1 < scrollView.contentOffset.x/320) {
        scrollPage.currentPage = 0;
    }else
        scrollPage.currentPage = scrollView.contentOffset.x/320;

}

- (void)pageSelect
{
    CGPoint point = CGPointMake(scrollPage.currentPage*320, 0);
    BannerScrollView.contentOffset = point;
}

- (void)loadBanner
{
    NSArray *bannerArray = [NSArray arrayWithContentsOfFile:[self getContentWithName:BANNER_PLIST_FILE]];
    //NSLog(@"banner array %@", bannerArray);
    bannerArrayCount = bannerArray.count;
    uint index = 0;
    BannerScrollView.contentSize = CGSizeMake(320*bannerArray.count, BannerScrollView.frame.size.height);
    BannerScrollView.pagingEnabled = YES;
    for (NSDictionary *bannerDic in bannerArray) {
        BannerImageView *bImageView = [[[BannerImageView alloc] initWithFrame:CGRectMake(index*320, 0, 320, BannerScrollView.frame.size.height)]autorelease];
        bImageView.userInteractionEnabled = YES;
        bImageView.clickUrl = [bannerDic safeObjectForKey:@"sClickUrl"];
        bImageView.isLocalJump = ((NSNumber *)[bannerDic safeObjectForKey:@"isLocalJump"]).boolValue;//unused
        NSNumber *isLocalImage = [bannerDic safeObjectForKey:@"isLocalImage"];
        if (isLocalImage.boolValue) {
            bImageView.image = [UIImage imageNamed:[bannerDic safeObjectForKey:@"localImageName"]];
        }else{
            [bImageView setImageWithURL:[NSURL URLWithString:[bannerDic safeObjectForKey:@"remoteImageUrl"]]];
        }
        bImageView.rootViewControl = self;
        [BannerScrollView addSubview:bImageView];
        index++;
    }
    
    scrollPage = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 95, 120, 20)];
    //[scrollPage addTarget:self action:@selector(pageSelect) forControlEvents:UIControlEventValueChanged];
    scrollPage.numberOfPages = bannerArrayCount;
    [baseScrollView addSubview:scrollPage];
    [scrollPage release];
    
    [self startBannerTimer];
}

- (void)refreshFanliNum
{
    NSArray *fanliInfoArray = [customFollowShopCart getFanliInfoToRefreshUI];
    NSLog(@"newOrderForFanli array %@", fanliInfoArray);
    if (!fanliInfoArray) {
        fanliTabBar.badgeValue = nil;
    }else{
        taobaokeCalculateObject *caiculate = [[taobaokeCalculateObject alloc] init];
        [caiculate recordTotalFanliWithArray:fanliInfoArray];
        caiculate.delegate = self;
    }
}

#pragma mark - search event

- (IBAction)editEnd:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)editBegin:(id)sender {
    [sender resignFirstResponder];
    SearchViewController *searchVC = [[[SearchViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    searchVC.hidesBottomBarWhenPushed = YES;
    [searchVC setIsTextFirstRespond:YES];
    [MobClick event:@"HomeSearch"];
    [self.navigationController pushViewController:searchVC animated:YES];
    searchVC.menuButton.hidden = YES;
}

- (IBAction)FirstButtonClick:(UIButton *)sender {
    
    taobaoShopCartViewViewController *webContentViewControl = nil;
    webContentViewControl = [[[taobaoShopCartViewViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    NSString *urlS = nil;
    NSURL *url2 = nil;
    
    switch (sender.tag) {
            //聚划算
        case 100:
            urlS = @"http://r.m.taobao.com/m3?p=mm_43457538_4062176_13208970&c=1005";
            [MobClick event:@"juhuasuanClick"];
            break;
            //天天特价
        case 101:
            urlS = @"http://r.m.taobao.com/m3?p=mm_43457538_4062176_13210967&c=1043";
            [MobClick event:@"DaySpecialSell"];
            break;
            //有爱频道
        case 102:
            
            break;
            
        //购物车
        case 1000:
            urlS = @"http://h5.m.taobao.com/cart/index.htm#cart";
            [MobClick event:@"taobaoShopCartModel"];
            break;
        //电脑模式
        case 1001:
            if(1)
            {
                PcShoppingViewController *pcVC = [[[PcShoppingViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                pcVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pcVC animated:YES];
                [MobClick event:@"pcShoppingModel"];
                return;
            }
            break;
            
            //男 导购
        case 2000:
            if(1)
            {
                DayRecommendViewController *pcVC = [[[DayRecommendViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                pcVC.hidesBottomBarWhenPushed = YES;
                pcVC.isBoy = YES;
                [self.navigationController pushViewController:pcVC animated:YES];
                [MobClick event:@"BoyShopping"];
                return;
            }
            break;
            //女 导购
        case 2001:
            if(1)
            {
                DayRecommendViewController *pcVC = [[[DayRecommendViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                pcVC.hidesBottomBarWhenPushed = YES;
                pcVC.isBoy = NO;
                [self.navigationController pushViewController:pcVC animated:YES];
                [MobClick event:@"GirlShopping"];
                return;
            }
            break;
            
            //女装
        case 0:
            urlS = @"http://r.m.taobao.com/m3?p=mm_43457538_4062176_13210966&c=1006";
            [MobClick event:@"GoodGirlClothes"];
            break;
            //卖手机频道 未使用
        case 3:
            urlS = @"http://r.m.taobao.com/m3?p=mm_43457538_4062176_13220017&c=1008";
            //[MobClick event:@"phoneCharge"];
            break;
            //话费充值链接
        case 5:
            //淘宝8月公告链接
            urlS = @"http://wvs.m.taobao.com?pid=mm_43457538_0_0&backHiddenFlag=1";
            //淘宝客频道链接
            //urlS = @"http://r.m.taobao.com/m3?p=mm_43457538_4062176_13218140&c=1561&ck=1";
            [MobClick event:@"phoneCharge"];
            break;
            
            //淘宝
        case 4:
            if(1)
            {
                taobaoChannelViewController *pcVC = [[[taobaoChannelViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                pcVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pcVC animated:YES];
                [MobClick event:@"taobaoChannel"];
                return;
            }
            break;
            //天猫
        case 6:
            if(1)
            {
                TmallChannelViewController *pcVC = [[[TmallChannelViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                pcVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pcVC animated:YES];
                [MobClick event:@"tmallChannel"];
                return;
            }
            break;
            
            //美丽说
        case 500:
            urlS = @"http://m.meilishuo.com/";
            [MobClick event:@"meilishuo"];
            break;
            //蘑菇街
        case 501:
            [self pretendAsPcForBrower];
            webContentViewControl.isNeedCustomCss = YES;
            urlS = @"http://m.mogujie.com/";
            [MobClick event:@"mogujie"];
            break;
            //折800
        case 502:
            [self pretendAsPcForBrower];
            webContentViewControl.isNeedCustomCss = YES;
            urlS = @"http://m.zhe800.com";
            [MobClick event:@"zhe800"];
            break;
            //天猫
            
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

- (void)pretendAsPcForBrower
{
    if (1) {
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/534.56.5 (KHTML, like Gecko) Version/5.1.6 Safari/534.56.5)", @"UserAgent", nil];//MSIE 8.0;
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        [dictionnary release];
        //Mozilla/4.0 (compatible; Windows NT 6.1; Trident/4.0)", @"UserAgent
    }else{
        
        NSString *iosv=[[UIDevice currentDevice]systemVersion] ;
        iosv=[iosv stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        
        NSString *agent=[NSString stringWithFormat:@"Mozilla/5.0 (iPhone; CPU iPhone OS %@ like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25",iosv];
        //NSLog(@"agent=%@",agent) ;
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:agent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        [dictionnary release];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:nil];
    }
}

- (void)setViewGes
{
    UITapGestureRecognizer *ges = nil;
    
    ges = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MainItemTap:)] autorelease];
    [taobaoImageView addGestureRecognizer:ges];
    
    ges = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MainItemTap:)] autorelease];
    [taobaoTejiataobaoImageView addGestureRecognizer:ges];
    
    ges = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MainItemTap:)] autorelease];
    [taobaoJuhuasuantaobaoImageView addGestureRecognizer:ges];
    
    ges = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MainItemTap:)] autorelease];
    [tmalltaobaoImageView addGestureRecognizer:ges];
    
    ges = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MainItemTap:)] autorelease];
    [tmallTemaitaobaoImageView addGestureRecognizer:ges];
    
    ges = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MainItemTap:)] autorelease];
    [taobaoSHopcarttaobaoImageView addGestureRecognizer:ges];
}

- (void)TotalFanliResult:(float)fanliValue
{
    [[AppDelegate getLeveyTabBarControl] setTabButtonNewFlag:4];
}

- (void)newOrderForFanli:(NSNotification *)notification
{
    NSLog(@"newOrderForFanli num %@", notification.object);
    
    if (!notification.object) {
        [[AppDelegate getLeveyTabBarControl] removeTabButtonNewFlag:4];
        return;
    }
    
    NSArray *array = notification.object;

    taobaokeCalculateObject *caiculate = [[taobaokeCalculateObject alloc] init];
    [caiculate recordTotalFanliWithArray:array];
    caiculate.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*UIImageView *bgImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]] autorelease];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.frame = CGRectMake(0, 40, 320, iphone5 ? 508 : 435);
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];*/
    
    [self.view setBackgroundColor:UIColorFromRGB(0xECF0F1)];
    
    baseScrollView.contentSize = CGSizeMake(320, iphone5 ? 800 : 883);
    [baseScrollView setBackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrderForFanli:) name:kUserFanliCount object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UMengOnlineData:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBarHidden = YES;
    
    //
    [self setViewGes];
    [self loadBanner];
    
    //第一次启动提醒
    /*NSNumber *shopcartFlag = [[NSUserDefaults standardUserDefaults] objectForKey:kShop_cart_Note];
    if (!shopcartFlag || !shopcartFlag.boolValue) {
        shopCartNote.frame = CGRectMake(0, iphone5 ? 0 : -80, 320, 548);
        [self.view addSubview:shopCartNote];
    }*/
    
    //net alert
    if([AppUtil IsEnable3G])
    {
        //[[RFToast sharedInstance] showToast:@"移动网络，建议使用wifi" inView:self.view];
    }else if([AppUtil IsEnableWIFI]){
        //[[RFToast sharedInstance] showToast:@"wifi网络下，淘宝品牌店铺页面自动使用高清模式" inView:self.view];
    }
    
    [self rankMe];
    
    return;
}

static NSString *noteRank = @"userNoteRank";

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int shareFlag = [[NSUserDefaults standardUserDefaults] integerForKey:noteRank];
    if (!buttonIndex) {
        //share
        shareFlag = -270;
        [[NSUserDefaults standardUserDefaults] setInteger:shareFlag forKey:noteRank];

        [MobClick event:@"rankMeByNote"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",667902169]]];
    }else{
        shareFlag = -70;
        [[NSUserDefaults standardUserDefaults] setInteger:shareFlag forKey:noteRank];
        [MobClick event:@"refuseRank"];
    }
}


- (void)rankMe
{
    
    int shareFlag = [[NSUserDefaults standardUserDefaults] integerForKey:noteRank];
    
    if (shareFlag == 10) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"给我一个评价，您的评价是我的动力" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"残忍的拒绝", nil] autorelease];
        [alertView show];
    }else
    {
        shareFlag++;
        [[NSUserDefaults standardUserDefaults] setInteger:shareFlag forKey:noteRank];
    }
    
}

- (void)UMengOnlineData:(NSNotification *)notification
{
    NSString *bannerData = [MobClick getConfigParams:@"banner"];
    NSArray *bannerArray = [bannerData componentsSeparatedByString:@"@@@***"];
    
    bannerArrayCount = bannerArray.count/2;
    
    BannerScrollView.contentSize = CGSizeMake(320*bannerArrayCount, BannerScrollView.frame.size.height);
    
    //clear subviews of BannerScrollView
    for (int i = 0; i < BannerScrollView.subviews.count; i++) {
        UIView *view = [BannerScrollView.subviews objectAtIndex:i];
        [view removeFromSuperview];
    }
    uint index = 0;
    for (int j = 0; j < bannerArrayCount; j++) {
        BannerImageView *bImageView = [[[BannerImageView alloc] initWithFrame:CGRectMake(index*320, 0, 320, BannerScrollView.frame.size.height)]autorelease];
        bImageView.tag = 1;
        bImageView.userInteractionEnabled = YES;
        bImageView.clickUrl = [bannerArray objectAtIndex:j*2+1];
        [bImageView setImageWithURL:[NSURL URLWithString:[bannerArray objectAtIndex:j*2]]];
        bImageView.rootViewControl = self;
        [BannerScrollView addSubview:bImageView];
        index++;
    }

    scrollPage.numberOfPages = bannerArrayCount;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    NSNumber *flagNum = [[NSUserDefaults standardUserDefaults] objectForKey:kNEW_SHOW_PIC];
    if (!flagNum || !flagNum.boolValue) {
        introducePic.frame = CGRectMake(0, iphone5 ? 0 : -40, 320, 548);
        [self.view addSubview:introducePic];
        [[AppDelegate getLeveyTabBarControl] hidesTabBar:YES animated:NO];
    }
    
    NSArray *array = [customFollowShopCart getFanliInfoToRefreshUI];
    NSLog(@"more num %@", array);
    if (!array) {
        //fanliDesLable.text = nil;
        return;
    }
    
    taobaokeCalculateObject *caiculate = [[taobaokeCalculateObject alloc] init];
    [caiculate recordTotalFanliWithArray:array];
    caiculate.delegate = self;
}

- (IBAction)hideShopcartNote:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kShop_cart_Note];
    [[AppDelegate getLeveyTabBarControl] hidesTabBar:NO animated:NO];
    [shopCartNote removeFromSuperview];
}


- (IBAction)hidePic:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kNEW_SHOW_PIC];
    [[AppDelegate getLeveyTabBarControl] hidesTabBar:NO animated:NO];
    [introducePic removeFromSuperview];
}

- (void)dealloc {
    [taobaoImageView release];
    [taobaoTejiataobaoImageView release];
    [taobaoJuhuasuantaobaoImageView release];
    [tmalltaobaoImageView release];
    [tmallTemaitaobaoImageView release];
    [taobaoSHopcarttaobaoImageView release];
    [BannerScrollView release];
    [introducePic release];
    [shopCartNote release];
    [baseScrollView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [BannerScrollView release];
    BannerScrollView = nil;
    [introducePic release];
    introducePic = nil;
    [shopCartNote release];
    shopCartNote = nil;
    [baseScrollView release];
    baseScrollView = nil;
    [super viewDidUnload];
}


#pragma mark - 
#pragma mark - shopping guide

- (IBAction)everyDayRecommend:(id)sender {
}

@end
