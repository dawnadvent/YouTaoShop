//
//  shopCell.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-24.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "shopCell.h"
#import "BannerImageView.h"

@implementation shopCell
{
    BannerImageView *shopImage0;
    BannerImageView *shopImage1;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rootViewCtrol:(UIViewController *)rVC
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        shopImage0 = [[[BannerImageView alloc] initWithFrame:CGRectMake(20, 0, 120, 225*0.8)] autorelease];
        shopImage0.contentMode = UIViewContentModeScaleAspectFit;
        shopImage0.rootViewControl = rVC;
        [self addSubview:shopImage0];
        shopImage1 = [[[BannerImageView alloc] initWithFrame:CGRectMake(180, 0, 120, 225*0.8)] autorelease];
        shopImage1.contentMode = UIViewContentModeScaleAspectFit;
        shopImage1.rootViewControl = rVC;
        [self addSubview:shopImage1];
        NSLog(@"cell %@ cell subview %@", self, self.subviews);
    }
    return self;
}

- (void)refreshCell:(NSString *)imageName sclick:(NSString *)click  image2:(NSString *) imageName2 sclick2:(NSString *)click2
{
    shopImage0.image = [UIImage imageNamed:imageName];
    shopImage0.clickUrl = click;
    shopImage1.image = [UIImage imageNamed:imageName2];
    shopImage1.clickUrl = click2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
