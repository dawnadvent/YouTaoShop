//
//  DetailViewController.m
//  Isvtrade
//
//  Created by tianqiao on 12-11-23.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "DetailViewController.h"
#import "TopToolBar.h"
#import "JDY_Constants.h"
#import "LoginUserInfo.h"
#import "TopAppService.h"
#import "TopIOSClient.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
TopToolBar *t;
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
    [self fillData:self.trade];
    NSString * appkey = [[LoginUserInfo sharedInstance]appkey];
    NSString* userId = [LoginUserInfo sharedInstance].userId;
    t =[TopToolBar bindBaseView:self.navigationController.view  withApp:appkey tmallStyle:YES unreadCountFromUser:userId];
    t.top = t.top + 20;
    [t retain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillData:(TradeDO *)trade
{
    if(trade!=nil){
        
        self.m_gmtCreate.text = trade.createTime;
        self.m_num.text = [[NSString alloc]initWithFormat:@"%u 笔订单",[trade getOrderCount]];
        self.m_price.text = [[NSString alloc]initWithFormat:@"%@ 元",trade.payment.description];
        self.m_title.text = trade.title.description;
        
        if ([trade getTradeImageUrl])
        {
            NSString * urlString  = [[NSString alloc]initWithFormat:@"%@_120x120.jpg",[trade getTradeImageUrl]];
            NSURL * url = [[NSURL alloc]initWithString:urlString];
            NSData* imageData = [NSData dataWithContentsOfURL:url];
            self.m_imageView.image = [[UIImage alloc]initWithData:imageData];
        }
        self.m_status.text = trade.status;
    }

}

- (void)dealloc {
    [_chatBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setChatBtn:nil];
    [super viewDidUnload];
}
- (IBAction)chatWithBuyer:(id)sender {
    
    NSString * appkey = [[LoginUserInfo sharedInstance] appkey];
    TopAppService* appservice = [TopAppService getAppServicebyAppKey:appkey];
   
    [appservice chat:[[LoginUserInfo sharedInstance] userId] chatNick:self.trade.buyerNick iid:@"16558866798"  tid:self.trade.tradeId text:@"你好，欢迎光临小店" params:nil];
    
}
@end
