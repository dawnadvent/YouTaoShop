//
//  DayRecommendViewController.h
//  fanli
//
//  Created by jiangwei.wu on 13-8-13.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayRecommendViewController : UIViewController
{
    IBOutlet UIButton *backDay;
    IBOutlet UIButton *goToTaobao;
    IBOutlet UIButton *gobackToToday;
}

@property (nonatomic, assign)BOOL isBoy;

@end
