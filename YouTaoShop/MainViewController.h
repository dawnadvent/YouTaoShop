//
//  MainViewController.h
//  fanli
//
//  Created by jiangwei.wu on 13-6-1.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "taobaokeCalculateObject.h"

@interface MainViewController : UIViewController<UITabBarDelegate, UIWebViewDelegate,taobaokeCalculateDelgete>
{
    
    IBOutlet UIScrollView *baseScrollView;
    IBOutlet UIImageView *introducePic;
    IBOutlet UIScrollView *BannerScrollView;
    
    IBOutlet UILabel *taobaoImageView;
    IBOutlet UILabel *taobaoTejiataobaoImageView;
    IBOutlet UILabel *taobaoJuhuasuantaobaoImageView;
    IBOutlet UILabel *tmalltaobaoImageView;
    IBOutlet UILabel *tmallTemaitaobaoImageView;
    IBOutlet UILabel *taobaoSHopcarttaobaoImageView;
    
    UIWebView *taobaoWebView;
}

@end
