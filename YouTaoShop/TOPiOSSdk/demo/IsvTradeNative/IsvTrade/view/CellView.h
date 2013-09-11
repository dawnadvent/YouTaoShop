//
//  CellView.h
//  Isvtrade
//
//  Created by tianqiao on 12-11-25.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeDO.h"

@interface CellView : UITableViewCell
@property (nonatomic,retain) IBOutlet UIImageView* m_imageView;

@property (nonatomic,retain) IBOutlet UILabel* m_title;

@property (nonatomic,retain) IBOutlet UILabel* m_num;

@property (nonatomic,retain) IBOutlet UILabel* m_status;

@property (nonatomic,retain) IBOutlet UILabel* m_price;

@property (nonatomic,retain) IBOutlet UILabel* m_gmtCreate;

@property (nonatomic,retain) IBOutlet UILabel* m_buyerNick;

-(void) fillData:(TradeDO*) trade;

@end
