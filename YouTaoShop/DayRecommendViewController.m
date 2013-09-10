//
//  DayRecommendViewController.m
//  fanli
//
//  Created by jiangwei.wu on 13-8-13.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "DayRecommendViewController.h"
#import "taobaoShopCartViewViewController.h"

@interface careImageView : UIImageView

@property (assign) UIScrollView *srcollSuperView;

@end

@implementation careImageView

- (void)setImage:(UIImage *)image
{
    [[SHKActivityIndicator currentIndicator] hide];
    [super setImage:image];
    CGFloat y = self.frame.origin.y;
    CGFloat height = image.size.height*(320/image.size.width);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 320, height);
    _srcollSuperView.contentSize = CGSizeMake(320, height + y);
    NSLog(@"image height %f width %f \nscroll contentSize height %f", image.size.height, image.size.width, height + y);
    
}

@end

@interface DayRecommendViewController ()
{
    IBOutlet UIScrollView *baseScrollView;
    
    IBOutlet UILabel *dataLable;
    IBOutlet UILabel *itemDesLable;
    IBOutlet careImageView *itemPic;
    
    IBOutlet UIView *titleView;
    
    int itemCount;
    int index;
}

@property (retain, nonatomic) NSString *clickUrl;

@end

@implementation DayRecommendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)back:(id)sender {
    [[SHKActivityIndicator currentIndicator] hide];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    itemPic.srcollSuperView = nil;
    SAFE_RELEASE(itemPic);
    SAFE_RELEASE(_clickUrl);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [backDay release];
    [goToTaobao release];
    [dataLable release];
    [itemDesLable release];
    [itemPic release];
    [baseScrollView release];
    [titleView release];
    [gobackToToday release];
    [super dealloc];
}

- (void)DayUMengOnlineData:(NSNotification *)notification
{
    index = 0;//reset
    [self refreshUIByUMengDate];
}

- (void)setDataToUi:(NSString *)stringData
{
    //item 4个
    static int itemElementCount = 4;
    //日期 一句话描述42个字以内(包括标点)  URL 图片URL
    NSArray *bannerArray = [stringData componentsSeparatedByString:@"@@@***"];
    itemCount = bannerArray.count/itemElementCount;
    int start = (itemCount - 1 - index)*itemElementCount;
    
    if (start < 0) {
        index = 0;
        [self setDataToUi:stringData];
        return;
    }else if (start > bannerArray.count - itemElementCount)
    {
        index = itemCount - 1;
        [self setDataToUi:stringData];
        return;
    }
    
    self.clickUrl = [bannerArray objectAtIndex:start + 2];
    NSString *dataString = [bannerArray objectAtIndex:start];
    if (![dataString hasPrefix:@" "]) {
        dataString = [NSString stringWithFormat:@" %@", dataString];
    }
    dataLable.text = dataString;
    itemDesLable.text = [bannerArray objectAtIndex:start + 1];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"推荐宝贝大图获取中..."];
    [itemPic setImageWithURL:[NSURL URLWithString:[bannerArray objectAtIndex:start+3]]];
}

- (void)refreshUIByUMengDate
{
    NSString *key = _isBoy ? @"everyDayBoyRecommend" : @"everyDayGirlRecommend";
    NSString *recommendData = [MobClick getConfigParams:key];
    
    if (recommendData) {
        [self setDataToUi:recommendData];
    }else{
        //reset index
        index = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DayUMengOnlineData:) name:UMOnlineConfigDidFinishedNotification object:nil];
    }
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
    
    dataLable.layer.borderWidth = 0.5;
    dataLable.layer.borderColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0].CGColor;
    
    //[itemDesLable setBackgroundColor:nil];
    itemPic.srcollSuperView = baseScrollView;
    //itemPic.image = [UIImage imageNamed:@"demoTaobao.jpg"];
    
    if (_isBoy) {
        [backDay setBackgroundImage:[UIImage imageNamed:@"goToBuy.png"] forState:UIControlStateNormal];
        [goToTaobao setBackgroundImage:[UIImage imageNamed:@"goToBuy.png"] forState:UIControlStateNormal];
        [gobackToToday setBackgroundImage:[UIImage imageNamed:@"goToBuy.png"] forState:UIControlStateNormal];
        [titleView setBackgroundColor:UIColorFromRGB(0x66CCCC)];
    }else{
        [titleView setBackgroundColor:UIColorFromRGB(0xFF99CC)];
    }
    
    [self refreshUIByUMengDate];
}

- (void)viewDidUnload {
    [backDay release];
    backDay = nil;
    [goToTaobao release];
    goToTaobao = nil;
    [dataLable release];
    dataLable = nil;
    [itemDesLable release];
    itemDesLable = nil;
    [itemPic release];
    itemPic = nil;
    [baseScrollView release];
    baseScrollView = nil;
    [titleView release];
    titleView = nil;
    [gobackToToday release];
    gobackToToday = nil;
    [super viewDidUnload];
}


- (IBAction)gotoToday:(id)sender {
    [MobClick event:@"huidaoJintian"];
    index = 0;
    [self refreshUIByUMengDate];
}

- (IBAction)backToPreDay:(id)sender {
    [MobClick event:@"shiguangDaoliu"];
    if (index == itemCount - 1) {
        [[RFToast sharedInstance] showToast:@"已经是最早的时光" inView:self.view];
        return;
    }
    index++;
    [self refreshUIByUMengDate];
}

- (IBAction)gotoTaobaoBuy:(id)sender {
    [MobClick event:@"GotoTaobao"];
    taobaoShopCartViewViewController *webContentViewControl = nil;
    webContentViewControl = [[[taobaoShopCartViewViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    NSURL *url2 = [NSURL URLWithString:_clickUrl];
    webContentViewControl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webContentViewControl animated:YES];
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
    
    [webContentViewControl.webView loadRequest:request];
}

@end
