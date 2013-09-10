//
//  ApiTaobaoInfo.h
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-29.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApiTaobaoFunc <NSObject>
@optional
- (void)taobaoke:(NSDictionary *)data;
- (void)getCid:(NSDictionary *)data;
- (void)getShop:(NSDictionary *)data;
@end

@interface ApiTaobaoInfo : NSObject

@property (nonatomic, retain)id delegateTaobaoKe;

@end
