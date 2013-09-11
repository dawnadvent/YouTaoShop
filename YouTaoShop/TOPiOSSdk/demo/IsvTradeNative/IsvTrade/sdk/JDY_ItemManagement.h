//
//  ItemManagement.h
//  TOPIOSSdk
//  商品模块插件必须实现的业务协议，作为应用跳转或者消息跳转的实现支持
//
//  Created by fangweng on 12-11-20.
//
//

#import <Foundation/Foundation.h>

//以下接口uid是系统必选传递参数
@protocol JDY_ItemManagement <NSObject>

//跳转到商品详情功能模块，iid是商品id（必选），notifyString（可选）如果有内容，
//代表是从消息中心过来，内容是消息中心的数据，具体结构参看推送信息结构描述
-(void) itemDetail:(NSString *)uid iid:(NSString *)iid notifyString:(NSString *)notifyString;


//跳转到商品列表，ItemStatus参看ProtocolConstants中的定义（可选）
-(void) itemList:(NSString *)uid itemStatus:(NSString *)itemStatus;

@end
