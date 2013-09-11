//
//  TradeDO.h
//  TradeManagementPlugIn
//
//  Created by tianqiao on 12-11-21.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeDO : NSObject
@property (nonatomic,copy) NSString* tradeId;
@property (nonatomic,copy) NSString* buyerNick;
@property (nonatomic,copy) NSString* payment;
@property (nonatomic,copy) NSString* postFee;
@property (nonatomic,copy) NSString* status;
@property (nonatomic,copy) NSString* createTime;
@property (nonatomic,copy) NSString* title;
@property (nonatomic,copy) NSString* payTime;
@property (nonatomic,retain) NSArray* orderList;

+(id)initList;
+(TradeDO *)initobject:(NSString *)tradeId;

-(NSUInteger)getOrderCount;

-(NSString *)getTradeImageUrl;

@end

/**
 
 01	{
 02	    "trade_get_response": {
 03	        "trade": {
 04	            "adjust_fee": "0.00",
 05	            "alipay_no": "2009062904095469",
 06	            "buyer_memo": "",
 07	            "buyer_nick": "tbtest1062",
 08	            "buyer_obtain_point_fee": 0,
 09	            "buyer_rate": true,
 10	            "cod_fee": "0.00",
 11	            "consign_time": "2009-06-29 16:58:07",
 12	            "created": "2009-06-29 16:55:59",
 13	            "discount_fee": "0.00",
 14	            "end_time": "2009-06-29 16:59:02",
 15	            "iid": "9444f147a20b22343cf38f3e67a1232c",
 16	            "modified": "2009-07-14 19:59:56",
 17	            "num": 2,
 18	            "orders": {
 19	                "order": [{
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
 38	                }]
 39	            },
 40	            "pay_time": "2009-06-29 16:56:18",
 41	            "payment": "2715.00",
 42	            "pic_path": "http://img01.taobao.net/bao/uploaded/i1/T1MVdXXi0uudLWYAQ2_045042.jpg",
 43	            "point_fee": 0,
 44	            "post_fee": "5.00",
 45	            "price": "1355.00",
 46	            "real_point_fee": 0,
 47	            "received_payment": "2715.00",
 48	            "seller_nick": "tbtest1061",
 49	            "seller_rate": true,
 50	            "shipping_type": "express",
 51	            "sid": "11569090",
 52	            "status": "TRADE_FINISHED",
 53	            "tid": 11569090,
 54	            "title": "妙妙的经典小窝",
 55	            "total_fee": "2710.00",
 56	            "type": "fixed"
 57	        }
 58	    }
 59	}
 **/
