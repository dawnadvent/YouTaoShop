//
//  AppEntity.h
//  TOPIOSSdk
//
//  app信息
//  Created by cenwenchu on 12-11-16.
//
//

#import <Foundation/Foundation.h>

@interface TopAppEntity : NSObject

@property(copy,nonatomic) NSString *appkey;
@property(copy,nonatomic) NSString *callbackUrl;
@property double timestamp;


@end
