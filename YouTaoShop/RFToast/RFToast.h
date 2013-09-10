//
//  RFToast.h
//  ChargeDemo
//
//  Created by roger qian on 13-1-10.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFToast : UIView
{
    @private 
    UILabel *_label;
    BOOL _stoped;
}

- (void)showToast:(NSString *)message inView:(UIView *)superView;
+ (id)sharedInstance;
@end
