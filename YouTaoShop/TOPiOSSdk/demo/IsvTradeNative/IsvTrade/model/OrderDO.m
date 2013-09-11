//
//  OrderDO.m
//  TradeManagementPlugIn
//
//  Created by tianqiao on 12-11-21.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "OrderDO.h"

@implementation OrderDO

+(OrderDO *) initObjectByDictionary:(NSDictionary *)json
{
    OrderDO* result = [[[OrderDO alloc]init]autorelease];
    result.title = [json objectForKey:@"title"];
    result.totalFee = [json objectForKey:@"total_fee"];
    result.num = [json objectForKey:@"num"];
    result.skuProperty = [json objectForKey:@"sku_properties_name"];
    result.picPath = [json objectForKey:@"pic_path"];
    result.orderId = [json objectForKey:@"oid"];
    return result;
}

@end

/**
 
 19	                {
 20	                    "adjust_fee": "0.00",
 21	                    "buyer_rate": "true",
 22	                    "discount_fee": "0.00",
 23	                    "iid": "9444f147a20b22343cf38f3e67a1232c",
 24	                    "item_meal_name": "耳机:充电器:电池",
 25	                    "num": 2,
 26	                    "oid": 11569090,
 27	                    "payment": "2715.00",
 28	                    "pic_path": "http://img01.taobao.net/bao/uploaded/i1/T1MVdXXi0uudLWYAQ2_045042.jpg",
 29	                    "price": "1355.00",
 30	                    "refund_status": "NO_REFUND",
 31	                    "seller_rate": "true",
 32	                    "seller_type": "C",
 33	                    "sku_id": "5265610",
 34	                    "sku_properties_name": "机身颜色:黑色;手机套餐:套餐二",
 35	                    "status": "TRADE_FINISHED",
 36	                    "title": "诺基亚001",
 37	                    "total_fee": "2710.00"
 38	                }
 **/
