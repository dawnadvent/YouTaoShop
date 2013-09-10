//
//  taobaokeCalculateObject.h
//  fanli
//
//  Created by 吴 江伟 on 13-7-11.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol taobaokeCalculateDelgete <NSObject>

@optional

- (void)TotalFanliResult:(float)fanliValue;

@end

@interface taobaokeCalculateObject : NSObject

- (void)recordTotalFanliWithArray:(NSArray *)array;

@property (assign, nonatomic) id <taobaokeCalculateDelgete> delegate;

@end
