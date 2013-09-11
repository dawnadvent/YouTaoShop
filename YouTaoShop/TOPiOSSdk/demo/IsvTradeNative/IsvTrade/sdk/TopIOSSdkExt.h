//
//  TopIOSSdkExt.h
//  TOPIOSSdk
//  扩展接口定义，主要用于类似于淘宝官方客户端的部分接口实现。
//
//  Created by cenwenchu on 12-11-13.
//
//

#import <Foundation/Foundation.h>
#import "TopApiResponse.h"

@protocol TopIOSSdkExt <NSObject>

//调用api入口(异步):  url支持向非TOP的网关发起类似TOP协议的请求，method请求的方法(GET,POST);params具体的业务和系统参数(可以不传，内部会有默认设置，如果要修改比如返回格式，可以设置);target和cb用于请求后传递结果回调（NSString或者NSError两种返回）
//userid如果传入，则可以根据授权状况自动选择不同的用户授权来请求服务，具体业务参看：http://open.taobao.com/doc/category_list.htm?id=102
//needMainThreadCallBack表明是否回调的时候采用主线程的方式回调（如果为true就采用主线程，主线程回调的作用是当回调函数需要操作ui界面的时候，必须是主线程，如果只是后台保存数据，这个值可以是false）
-(void)api:(NSString *) url method:(NSString *)method params:(NSDictionary *)params target:(id)target cb:(SEL)cb userId:(NSString *)userId  needMainThreadCallBack:(Boolean) needMainThreadCallBack;


//调用api入口(同步):  url支持向非TOP的网关发起类似TOP协议的请求，method请求的方法(GET,POST);params具体的业务和系统参数(可以不传，内部会有默认设置，如果要修改比如返回格式，可以设置);
//userid如果传入，则可以根据授权状况自动选择不同的用户授权来请求服务，具体业务参看：http://open.taobao.com/doc/category_list.htm?id=102
//返回结果是NSString或者NSError
-(TopApiResponse *)api:(NSString *) url method:(NSString *)method params:(NSDictionary *)params userId:(NSString *)userId;



@end
