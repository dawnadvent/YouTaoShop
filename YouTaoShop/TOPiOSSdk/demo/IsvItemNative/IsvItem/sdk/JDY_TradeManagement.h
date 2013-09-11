//
//  TradeManagement.h
//  TOPIOSSdk
//  交易模块插件必须实现的业务协议，作为应用跳转或者消息跳转的实现支持
//  Created by fangweng on 12-11-20.
//
//

#import <Foundation/Foundation.h>

//以下接口uid是系统必选传递参数
@protocol JDY_TradeManagement <NSObject>

//跳转到交易详情功能模块，tid是交易id（必选），notifyString（可选）如果有内容，
//代表是从消息中心过来，内容是消息中心的数据，具体结构参看推送信息结构描述
-(void) tradeDetail:(NSString *)uid tid:(NSString *)tid notifyString:(NSString *)notifyString;


//跳转到交易列表（所有参数都可选），tradeStatus参看ProtocolConstants中的定义,buyerNick买家信息，startCreated交易创建时间的下限，endCreated交易创建时间上限
-(void) tradeList:(NSString *)uid tradeStatus:(NSString *)tradeStatus buyerNick:(NSString *)buyerNick startCreated:(double)startCreated endCreated:(double)endCreated;

@end
