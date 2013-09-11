//
//  TradeDO.m
//  TradeManagementPlugIn
//
//  Created by tianqiao on 12-11-21.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "TradeDO.h"
#import "OrderDO.h"
#import "TopApiCallUtil.h"

@implementation TradeDO


+(id)initList
{
    NSMutableArray * resultList = [NSMutableArray arrayWithCapacity:10];
    NSString * tsql =@"select tid,buyer_nick,payment,post_fee,status,pay_time,created,title,orders.title, orders.pic_path, orders.price, orders.num,  orders.refund_status, orders.status, orders.oid, orders.total_fee, orders.payment, orders.discount_fee, orders.sku_properties_name, orders.item_meal_name from taobao.trades.sold.get where page_size=10";
    NSDictionary* dict = [TopApiCallUtil getJsonObject:tsql];
    if([TopApiCallUtil getError:dict] == nil){
        id response = [[[dict objectForKey:@"trades_sold_get_response"]objectForKey:@"trades"]objectForKey:@"trade"];
        for(NSDictionary * json in response){
            TradeDO *result = [[TradeDO initObjectByDictionary:json needOrder:true] retain];
            [resultList addObject:result];
        }
    }else{
        NSLog(@"TOP API ERROR:%@",[TopApiCallUtil getError:dict]);
    }
    return resultList;
    
}
+(TradeDO *)initobject:(NSString *)tradeId
{
    NSString * tsql =[NSString stringWithFormat:
    @"select tid,buyer_nick,payment,post_fee,status,pay_time,created,title,orders.title, orders.pic_path, orders.price, orders.num,  orders.refund_status, orders.status, orders.oid, orders.total_fee, orders.payment, orders.discount_fee, orders.sku_properties_name, orders.item_meal_name from taobao.trade.get where tid = %@",tradeId ];
    NSDictionary* dict = [TopApiCallUtil getJsonObject:tsql];
    if([TopApiCallUtil getError:dict] == nil){
        id response = [[dict objectForKey:@"trade_get_response"]objectForKey:@"trade"];
        return [self initObjectByDictionary:response needOrder:true];
    }else{
        NSLog(@"TOP API ERROR:%@",[TopApiCallUtil getError:dict]);
    }
    return nil;
    
    
}

+(TradeDO *) initObjectByDictionary:(NSDictionary *)json needOrder:(bool) needOrder{
    TradeDO *result = [[[TradeDO alloc]init] autorelease];
    result.tradeId = [json objectForKey:@"tid"];
    result.buyerNick = [json objectForKey:@"buyer_nick"];
    result.payment = [json objectForKey:@"payment"];
    result.postFee = [json objectForKey:@"post_fee"];
    result.status = [json objectForKey:@"status"];
    result.payTime = [json objectForKey:@"pay_time"];
    result.createTime = [json objectForKey:@"created"];
    result.title = [json objectForKey:@"title"];
    if(needOrder){
        id orderList = [[json objectForKey:@"orders"] objectForKey:@"order"];
        NSMutableArray * resultList = [NSMutableArray arrayWithCapacity:10];
        for(NSDictionary * tradeJson in orderList){
            OrderDO * trade = [OrderDO initObjectByDictionary:tradeJson];
            [resultList addObject:trade];
        }
        result.orderList = resultList;
    }
    return result;
}

-(NSUInteger)getOrderCount
{
    return self.orderList.count;
}

-(NSString *)getTradeImageUrl
{
    OrderDO* firstOrder =  [self.orderList objectAtIndex:0];
    if(firstOrder!=nil){
        return firstOrder.picPath;
    }
    return nil;
}

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
