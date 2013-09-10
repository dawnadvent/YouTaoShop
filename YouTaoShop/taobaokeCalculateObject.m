//
//  taobaokeCalculateObject.m
//  fanli
//
//  Created by 吴 江伟 on 13-7-11.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "taobaokeCalculateObject.h"
#import "TopIOSClient.h"
#import "taobaoData.h"
#import "customFollowShopCart.h"

@implementation taobaokeCalculateObject

+ (NSArray *)getPidsFromFanliArray:(NSArray *)fanliArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    
    for (NSDictionary *dic in fanliArray) {
        NSArray *pidArray = [dic safeObjectForKey:kFanliInfo];
        [array addObjectsFromArray:pidArray];
    }
    
    return array;
}

- (void)recordTotalFanliWithArray:(NSArray *)array
{
    [self sendTaobaokeWithArray:[taobaokeCalculateObject getPidsFromFanliArray:array]];
}

#pragma mark - taobao api

-(void)sendTaobaokeWithArray:(NSArray *)tids
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    NSMutableString *arrayString = [[NSMutableString alloc] init];
    
    int flag = 0;
    
    for (NSString *tid in tids) {
        if (!flag) {
            [arrayString appendFormat:@"%@", tid];
        }else
            [arrayString appendFormat:@",%@", tid];
        flag ++;
    }
    
    if (!arrayString.length) {
        [params release];
        [arrayString release];
        return;
    }
    
    [params setObject:@"taobao.taobaoke.widget.items.convert" forKey:@"method"];
    [params setObject:@"shop_click_url,\
     nick,seller_credit_score,\
     num_iid,\
     title,pic_url,price,promotion_price,commission,commission_rate,click_url" forKey:@"fields"];
    NSLog(@"arrayString calculate %@",arrayString);
    [params setObject:arrayString forKey:@"num_iids"];
    [params setObject:@"true" forKey:@"is_mobile"];
    TopIOSClient *iosClient =[TopIOSClient getIOSClientByAppKey:kTaobaoKey];
    
    [iosClient api:@"POST" params:params target:self cb:@selector(fanliResponse:) userId:@""needMainThreadCallBack:true];
    [params release];
    [arrayString release];
}

#pragma mark - add taobaoke info to single instance

-(void)fanliResponse:(id)data
{
    float totalFanli = 0;
    
    NSMutableArray *deleteArray = [NSMutableArray arrayWithCapacity:2];
    
    if ([data isKindOfClass:[TopApiResponse class]])
    {
        TopApiResponse *response = (TopApiResponse *)data;
        if ([response content])
        {
            NSDictionary *dic=(NSDictionary *)[[response content] JSONValue];
            NSLog(@"dic %@", dic);
            NSDictionary *dic1=[dic objectForKey:@"taobaoke_widget_items_convert_response"];
            NSDictionary *dic2=[dic1 objectForKey:@"taobaoke_items"];
            NSArray *array =[dic2 objectForKey:@"taobaoke_item"];
            
            for (NSDictionary *taobaokeDic in array) {
                //NSNumber *taobaoId = [taobaokeDic objectForKey:@"num_iid"];
                //NSString *taobaoS = [NSString stringWithFormat:@"%lld", taobaoId.longLongValue];
                //NSLog(@"array .count %@", array);
            
                NSNumber *commission_rate=[taobaokeDic objectForKey:@"commission_rate"];
                NSNumber *p1=[taobaokeDic objectForKey:@"promotion_price"];
                NSNumber *num_iid = [taobaokeDic objectForKey:@"num_iid"];
                if (!p1) {
                    p1=[taobaokeDic objectForKey:@"price"];
                }
                
                //返利多少钱RMB
                CGFloat moneyF = [AppUtil convertFanliNum:(commission_rate.floatValue/10000)*p1.floatValue];
                if (!moneyF) {
                    NSString *s_num_iid = [num_iid stringValue];
                    [deleteArray addObject:s_num_iid];
                }
                totalFanli += moneyF;
                NSLog(@"moneyF %f  totalFanli %f", moneyF, totalFanli);
            }
   
        }
    }
    
    if (deleteArray.count) {
        [customFollowShopCart deleteItemInFanliInfoDisk:deleteArray];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(TotalFanliResult:)]) {
        [_delegate TotalFanliResult:totalFanli];
    }
}

@end
