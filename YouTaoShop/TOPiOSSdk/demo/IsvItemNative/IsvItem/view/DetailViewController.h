//
//  DetailViewController.h
//  IsvItem
//
//  Created by tianqiao on 12-11-23.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDO.h"

@interface DetailViewController : UIViewController

@property (nonatomic,retain) IBOutlet UIImageView* m_imageView;

@property (nonatomic,retain) IBOutlet UITextField* m_title;

@property (nonatomic,retain) IBOutlet UITextField* m_num;

@property (nonatomic,retain) IBOutlet UITextField* m_status;

@property (nonatomic,retain) IBOutlet UITextField* m_price;

@property (nonatomic,retain) IBOutlet UITextField* m_gmtCreate;

-(void) fillData:(ItemDO*) item;

@property (nonatomic,retain) ItemDO* item;

@end
