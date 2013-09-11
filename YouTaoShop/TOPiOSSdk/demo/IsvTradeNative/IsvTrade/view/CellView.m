//
//  CellView.m
//  Isvtrade
//
//  Created by tianqiao on 12-11-25.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "CellView.h"

@implementation CellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)fillData:(TradeDO *)trade
{
    if(trade!=nil){
        self.m_gmtCreate.text = trade.createTime;
        self.m_num.text = [[NSString alloc]initWithFormat:@"%u 笔订单",[trade getOrderCount]];
        self.m_price.text = [[NSString alloc]initWithFormat:@"%@ 元",trade.payment.description];
        self.m_title.text = trade.title.description;
        NSString * urlString  = [[NSString alloc]initWithFormat:@"%@_120x120.jpg",[trade getTradeImageUrl]];
        NSURL * url = [[NSURL alloc]initWithString:urlString];
        NSData* imageData = [NSData dataWithContentsOfURL:url];
        self.m_imageView.image = [[UIImage alloc]initWithData:imageData];
    }
}

@end


//@property (nonatomic,copy) NSString* tradeId;
//@property (nonatomic,copy) NSString* buyerNick;
//@property (nonatomic,copy) NSString* payment;
//@property (nonatomic,copy) NSString* postFee;
//@property (nonatomic,copy) NSString* status;
//@property (nonatomic,copy) NSString* createTime;
//@property (nonatomic,copy) NSString* title;
//@property (nonatomic,copy) NSString* payTime;
