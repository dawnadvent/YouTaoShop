//
//  AppService.h
//  TOPIOSSdk
//
//  Created by fangweng on 12-11-21.
//
//

#import <Foundation/Foundation.h>
#import "JDY_Protocol.h"
#import "TopAppConnector.h"

@interface TopAppService : NSObject<JDY_ItemManagement,JDY_TradeManagement,JDY_RefundManagement,JDY_WangWangCommunication,JDY_MsgCenterManagement>

@property(nonatomic,retain) TopAppConnector * appConnector;

+(id)registerAppService:(NSString *)appKey appConnector:(TopAppConnector *) appConnector;

+(TopAppService *)getAppServicebyAppKey:(NSString *)appKey;

@end
