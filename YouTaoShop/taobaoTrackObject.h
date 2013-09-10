//
//  taobaoTrackObject.h
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-30.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kIS_PRODUCT_BE_FOLLOWED_KEY  @"wjwProductRecordType"

typedef enum {
    e_User_Scan_Product = 0,
    e_User_Detail_Followed_Product = 100,
    e_User_Shopcart_Followed_Product = 200
}eProcutRecordType;

//仅仅支持单线程操作实例

@interface taobaoTrackObject : NSMutableArray

+ (NSMutableArray *)sharedInstance;

+(void)AddTaobaokeInfoToSInstance:(NSDictionary *)taobaokeDic;

+ (NSMutableDictionary *)getTaobaokeInfoByPid:(NSNumber *)tid;

+ (BOOL)isThisTidNeedFollow:(NSNumber *)tid;

+ (void)setProduct:(NSNumber *)tid RecordType:(eProcutRecordType)productRecordType;

//聚划算
+ (void)setProduct:(NSNumber *)tid CommissionRate:(NSNumber *)rate;

@end
