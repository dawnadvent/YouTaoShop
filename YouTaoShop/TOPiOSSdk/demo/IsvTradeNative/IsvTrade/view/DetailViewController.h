//
//  DetailViewController.h
//  Isvtrade
//
//  Created by tianqiao on 12-11-23.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeDO.h"

@interface DetailViewController : UIViewController

@property (nonatomic,retain) IBOutlet UIImageView* m_imageView;

@property (nonatomic,retain) IBOutlet UITextField* m_title;

@property (nonatomic,retain) IBOutlet UITextField* m_num;

@property (nonatomic,retain) IBOutlet UITextField* m_status;

@property (nonatomic,retain) IBOutlet UITextField* m_price;

@property (nonatomic,retain) IBOutlet UITextField* m_gmtCreate;
@property (retain, nonatomic) IBOutlet UIButton *chatBtn;

-(void) fillData:(TradeDO*) trade;

@property (nonatomic,retain) TradeDO* trade;
- (IBAction)chatWithBuyer:(id)sender;

@end
