//
//  FilterTaobaoTaobaoProduct.h
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-29.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    //虚拟商品无返利
    VIRTUAL_TAOBAO_PRODUCT,
    //聚划算商品返利特殊，需要特殊处理
    JUHUASUAN_TAOBAO_PRODUCT,
    //有返利商品
    NORMAL_TAOBAO_PRODUCT
}TAOBAO_FANLI_TYPE;


@interface FilterTaobaoTaobaoProduct : NSObject

//获取过滤淘宝商品类目，这些类目无返利
+ (NSArray *)getFilterCid;

+ (NSString *)dataFilePath:(NSString *)fileName;

@end
