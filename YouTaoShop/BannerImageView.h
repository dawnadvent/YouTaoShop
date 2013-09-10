//
//  BannerImageView.h
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-24.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerImageView : UIImageView

@property (nonatomic, assign)UIViewController *rootViewControl;

@property (nonatomic, assign)BOOL isLocalJump;
@property (nonatomic, copy)NSString *clickUrl;

@end
