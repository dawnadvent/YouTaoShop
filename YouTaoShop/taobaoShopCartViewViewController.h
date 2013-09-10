//
//  taobaoShopCartViewViewController.h
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-29.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "customFollowShopCart.h"
#import "NJKWebViewProgress.h"
#import "taobaoFollowShopCartUntil.h"

typedef enum {
    //关键词搜索，展现淘宝搜索页面，展现选择宝贝框
    SEARCH_KEY,
    //某个收藏宝贝搜索，先后台进入淘宝详情页面，然后JS取出其中数据，根据商品详细名字以及店铺名字取出商品，然后进行跟单
    SEAACH_ONE_PRODUCT,
    
    //淘宝购物车跟单
    FROM_TAOBAO_SHOPCART
}eWebPageType;

@interface taobaoShopCartViewViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,CookieWebViewLoadDelegate, UIAlertViewDelegate,FollowTaobaoSClickDelegate,NJKWebViewProgressDelegate>

//@property (assign, nonatomic) eWebPageType webPageType;

@property (assign, nonatomic) BOOL alertShopCartFanli;

//@property (assign, nonatomic) BOOL isDirectTaobaoShopCart;

//@property (assign, nonatomic) BOOL isRedirectToSearch;
//@property (copy, nonatomic) NSString *redictUrlString;

@property (assign) BOOL isNeedCustomCss;

@property (retain, nonatomic) IBOutlet UIButton *returnButton;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UILabel *fanliNumberLable;

@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) IBOutlet UIImageView *forwardImage;
@property (retain, nonatomic) IBOutlet UIImageView *refreshImage;
@property (retain, nonatomic) IBOutlet UIView *ToolBaseView;
@property (retain, nonatomic) IBOutlet UIImageView *favImageView;

- (BOOL)didTidExist:(NSNumber *)tid;

- (IBAction)returnClick:(id)sender;

- (void)refreshFanliLable:(NSString *)labText;

@end
