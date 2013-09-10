//
//  shopCell.h
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-24.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shopCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rootViewCtrol:(UIViewController *)rVC;

- (void)refreshCell:(NSString *)imageName sclick:(NSString *)click  image2:(NSString *) imageName2 sclick2:(NSString *)click2;

@end
