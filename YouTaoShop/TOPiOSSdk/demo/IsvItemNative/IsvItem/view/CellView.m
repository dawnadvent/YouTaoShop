//
//  CellView.m
//  IsvItem
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


-(void)fillData:(ItemDO *)item
{
    self.m_gmtCreate.text = @"2012-12-22 00:00:00";
    self.m_num.text = [[NSString alloc]initWithFormat:@"%@ 件宝贝",item.num.description];
    self.m_price.text = [[NSString alloc]initWithFormat:@"%@ 元",item.price.description];
    self.m_title.text = item.itemTitle.description;
    
    NSString * urlString  = [[NSString alloc]initWithFormat:@"%@_120x120.jpg",[item itemImageUrl]];
    NSURL * url = [[NSURL alloc]initWithString:urlString];
    NSData* imageData = [NSData dataWithContentsOfURL:url];
    self.m_imageView.image = [[UIImage alloc]initWithData:imageData];
}

@end
