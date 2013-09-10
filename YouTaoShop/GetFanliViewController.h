//
//  GetFanliViewController.h
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-13.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetFanliViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIScrollView *NoticeScrollView;

@property (retain, nonatomic) IBOutlet UIImageView *MTaobaoOrderImageView;
@property (retain, nonatomic) IBOutlet UIImageView *TaobaoOrderImageView;

- (IBAction)SendMail:(id)sender;
- (IBAction)back:(id)sender;

@end
