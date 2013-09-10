//
//  ProductInfoCell.h
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-17.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoCell : UITableViewCell

@property (nonatomic, copy)NSNumber *pid;
@property (nonatomic, copy)NSString *pName;

- (void)refreshCellWithDic:(NSMutableDictionary *)dic;

@end
