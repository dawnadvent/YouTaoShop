//
//  ProductInfoCell.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-17.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "ProductInfoCell.h"
#import "taobaoData.h"

@implementation ProductInfoCell
{
    UIImageView *imageView;
    
    UILabel *productName;
    UILabel *shopName;
    
    UILabel *price;
    UILabel *fanliNum;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 80, 80)] autorelease];
        [self addSubview:imageView];
        
        productName = [[[UILabel alloc] initWithFrame:CGRectMake(90, 5, 320-90, 40)] autorelease];
        [productName setBackgroundColor:[UIColor clearColor]];
        productName.numberOfLines = 2;
        productName.font = [UIFont boldSystemFontOfSize:14.0];
        productName.textColor = [UIColor darkTextColor];
        [self addSubview:productName];
        
        price = [[[UILabel alloc] initWithFrame:CGRectMake(90, 45, 90, 26)] autorelease];
        [price setBackgroundColor:[UIColor clearColor]];
        price.font = [UIFont boldSystemFontOfSize:17.0];
        price.textColor = [UIColor redColor];
        [self addSubview:price];
        
        UILabel *comeLable = [[[UILabel alloc] initWithFrame:CGRectMake(185, 55, 40, 24)] autorelease];
        [comeLable setBackgroundColor:[UIColor clearColor]];
        comeLable.text = @"来自：";
        comeLable.font = [UIFont systemFontOfSize:13.0];
        comeLable.textColor = [UIColor lightGrayColor];
        [self addSubview:comeLable];

        shopName = [[[UILabel alloc] initWithFrame:CGRectMake(223, 42, 320-200, 50)] autorelease];
         [shopName setBackgroundColor:[UIColor clearColor]];
        shopName.numberOfLines = 2;
        shopName.font = [UIFont systemFontOfSize:13.0];
        shopName.textColor = [UIColor darkGrayColor];
        [self addSubview:shopName];
        
        fanliNum = [[[UILabel alloc] initWithFrame:CGRectMake(90, 70, 260, 25)] autorelease];
         [fanliNum setBackgroundColor:[UIColor clearColor]];
        fanliNum.font = [UIFont systemFontOfSize:15.0];
        fanliNum.textColor = [UIColor darkGrayColor];
        [self addSubview:fanliNum];
    }
    return self;
}

- (void)refreshCellWithDic:(NSMutableDictionary *)dic
{

    self.pid = [dic safeObjectForKey:@"num_iid"];
    self.pName = [dic safeObjectForKey:@"title"];
    
    NSString *picUrl = [dic safeObjectForKey:@"pic_url"];
    picUrl = [NSString stringWithFormat:@"%@_160x160.jpg", picUrl];
    [imageView setImageWithURL:[NSURL URLWithString:picUrl]];
    
    productName.text = [dic safeObjectForKey:@"title"];
        
    price.text = [NSString stringWithFormat:@"￥%@", [dic safeObjectForKey:@"promotion_price"]];
        
    shopName.text =  [dic safeObjectForKey:@"nick"];
    
    NSNumber *commission_rate=[dic objectForKey:@"commission_rate"];
    NSNumber *p1=[dic objectForKey:@"promotion_price"];
    
    if (!p1) {
        p1=[dic objectForKey:@"price"];
    }
    
    //返利多少钱RMB
    CGFloat moneyF = [AppUtil convertFanliNum:(commission_rate.floatValue/10000)*p1.floatValue];
    //NSLog(@"dic3=%@=%f",dic,moneyF);
    
    if (!moneyF) {
        fanliNum.text = @"返0.0元";
    }else{
        fanliNum.text = [NSString stringWithFormat:@"返%.2f元", moneyF];
    }

        

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
