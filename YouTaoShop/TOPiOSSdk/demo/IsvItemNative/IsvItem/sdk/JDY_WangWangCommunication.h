//
//  WangWangCommunication.h
//  TOPIOSSdk
//  旺旺模块插件必须实现的业务协议，作为应用跳转或者消息跳转的实现支持
//  Created by fangweng on 12-11-20.
//
//

#import <Foundation/Foundation.h>

@protocol JDY_WangWangCommunication <NSObject>

//旺旺聊天接口，nick必选（聊天对象nick），iid和tid可选，分别是商品id和交易id，带到聊天中
-(void) chat:(NSString *)uid nick:(NSString *)nick iid:(NSString *)iid tid:(NSString *)tid;

@end
