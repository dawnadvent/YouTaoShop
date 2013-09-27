//
//  FollowOrderRules.h
//  fanli
//
//  Created by 吴江伟 on 13-9-12.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowOrderRules : NSObject

/*return value:YES:get All String succeed,NO:get pid failed,using webUrl pid*/

+(BOOL)preLoadGetFollowInfoString:(UIWebView *)webview Url:(NSString *)webUrl ProductNameString:(NSString **)nameString ProductPidString:(NSString **)pidString;

+(BOOL)finishLoadGetFollowInfoString:(UIWebView *)webview Url:(NSString *)webUrl ProductNameString:(NSString **)nameString ProductPidString:(NSString **)pidString;

@end
