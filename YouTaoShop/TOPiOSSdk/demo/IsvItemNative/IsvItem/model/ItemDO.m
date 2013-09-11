//
//  ItemDO.m
//  IsvItem
//
//  Created by tianqiao on 12-11-24.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "ItemDO.h"
#import "TopApiCallUtil.h"


@implementation ItemDO

+(id)initOnsaleList{
    NSMutableArray * resultList = [NSMutableArray arrayWithCapacity:10];
    NSString * tsql =@"select num_iid,pic_url,approve_status,price,delist_time,title,num from taobao.items.onsale.get";
    NSDictionary* dict = [TopApiCallUtil getJsonObject:tsql];
    if([TopApiCallUtil getError :dict] == nil){
        id response = [[[dict objectForKey:@"items_onsale_get_response"]objectForKey:@"items"]objectForKey:@"item"];
        for(NSDictionary * json in response){
            ItemDO *result = [self initObjectByDictionary:json];
            [resultList addObject:result];
        }
    }else{
        NSLog(@"TOP API ERROR:%@",[TopApiCallUtil getError :dict]);
    }
    return resultList;
}

+(id)initAllList{
    NSMutableArray * resultList = [NSMutableArray arrayWithCapacity:10];
    NSString * tsql =@"select num_iid,pic_url,approve_status,price,delist_time,title,num from taobao.items.list.get ";
    NSDictionary* dict = [TopApiCallUtil getJsonObject:tsql];
    if([TopApiCallUtil getError :dict] == nil){
        id response = [[[dict objectForKey:@"items_list_get_response"]objectForKey:@"items"]objectForKey:@"item"];
        for(NSDictionary * json in response){
            ItemDO *result = [self initObjectByDictionary:json];
            [resultList addObject:result];
        }
    }else{
        NSLog(@"TOP API ERROR:%@",[TopApiCallUtil getError :dict]);

    }
    return resultList;
}

+(id)initObject :(NSString*) itemId{
    NSString * tsql = [NSString stringWithFormat:@"select num_iid,pic_url,approve_status,price,delist_time,title,num from taobao.item.get where num_iid = %@",itemId];
    NSDictionary* dict = [TopApiCallUtil getJsonObject:tsql];
    
    if([TopApiCallUtil getError :dict] == nil){
        NSDictionary * json = [[dict objectForKey:@"item_get_response"]objectForKey:@"item"];
        return [self initObjectByDictionary:json];
    }else{
        NSLog(@"TOP API ERROR:%@",[TopApiCallUtil getError :dict]);
        return nil;
    }
    return nil;
}
+(ItemDO *) initObjectByDictionary:(NSDictionary *)json{
    ItemDO *result = [[[ItemDO alloc]init] autorelease];
    result.itemId = [json objectForKey:@"num_iid"];
    result.itemImageUrl = [json objectForKey:@"pic_url"];
    result.itemTitle = [json objectForKey:@"title"];
    result.status = [json objectForKey:@"approve_status"];
    result.price = [json objectForKey:@"price"];
    result.props = [json objectForKey:@"props"];
    result.cid = [json objectForKey:@"cid"];
    result.num = [json objectForKey:@"num"];
    return result;
}

+(NSString *) addObject:(ItemDO*) item{
    
    item.props=@"1740089:11058;20000:4357282";
    item.cid=@"1512";
    NSString* parmList=@"num,price,type,stuff_status,title,desc,location.state,location.city,cid,props";
    NSString* valueList=[NSString stringWithFormat:@"100,%@,fixed,new,%@,卖家无线测试,浙江,杭州,%@,%@",item.price,item.itemTitle,item.cid,item.props];
    
    NSString * tsql =
    [NSString stringWithFormat:@"insert into item (%@) values (%@)",parmList,valueList];
    
    NSDictionary* dict = [TopApiCallUtil getJsonObject:tsql method:@"POST"];
    if([TopApiCallUtil getError :dict] == nil){
        return @"success";
    }else{
        NSLog(@"TOP API ERROR:%@",[TopApiCallUtil getError :dict]);
        return [TopApiCallUtil getError :dict];
    }
}

+(NSString *) editObject:(ItemDO*) item{
    
    NSString * tsql =
    [NSString stringWithFormat:@"update item set title = %@ ,price= %@ where num_iid=%@",item.itemTitle,item.price,item.itemId];
    NSDictionary* dict = [TopApiCallUtil getJsonObject:tsql method:@"POST"];
    if([TopApiCallUtil getError :dict] == nil){
        return @"success";
    }else{
        NSLog(@"TOP API ERROR:%@",[TopApiCallUtil getError :dict]);
        return [TopApiCallUtil getError :dict];
    }
}

@end
