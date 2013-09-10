//
//  MoreViewController.h
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-24.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "taobaokeCalculateObject.h"
#import "UMSocial.h"

@interface MoreViewController : UIViewController<taobaokeCalculateDelgete, UMSocialUIDelegate, UIAlertViewDelegate>

+ (CGFloat)getUserFanliTotal;

@end
