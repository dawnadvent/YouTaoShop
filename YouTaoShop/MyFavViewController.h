//
//  MyFavViewController.h
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-17.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFavViewController : UIViewController<UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (assign, nonatomic) BOOL isShopCart;
@property (assign, nonatomic) BOOL isHomeFav;
@property (copy, nonatomic) NSArray *shopCartArray;

//- (void)setTitleViewHidden;
@property (retain, nonatomic) IBOutlet UIButton *menuButton;
@property (retain, nonatomic) IBOutlet UIButton *backButton;

@end
