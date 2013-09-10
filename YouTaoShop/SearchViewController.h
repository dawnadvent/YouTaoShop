//
//  SearchViewController.h
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-11.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (assign, nonatomic) BOOL isTextFirstRespond;
@property (retain, nonatomic) IBOutlet UITextField *searchTextView;

@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIButton *menuButton;
@end
