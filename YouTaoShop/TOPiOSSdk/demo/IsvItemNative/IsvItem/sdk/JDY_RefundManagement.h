//
//  RefundManagement.h
//  TOPIOSSdk
//  退款模块插件必须实现的业务协议，作为应用跳转或者消息跳转的实现支持
//  Created by fangweng on 12-11-20.
//
//

#import <Foundation/Foundation.h>

//以下接口uid是系统必选传递参数
@protocol JDY_RefundManagement <NSObject>

//跳转到退款详情功能模块，refundid是退款id（必选），notifyString（可选）如果有内容，
//代表是从消息中心过来，内容是消息中心的数据，具体结构参看推送信息结构描述
-(void) refundDetail:(NSString *)uid refundId:(NSString *)refundId notifyString:(NSString *)notifyString;


//跳转到退款列表（所有参数都可选），refundStatus参看ProtocolConstants中的定义,buyerNick买家信息
-(void) refundList:(NSString *)uid refundStatus:(NSString *)refundStatus buyerNick:(NSString *)buyerNick;


@end
