//
//  TopBrageWebview.h
//  BrageWebView
//
//  Created by lihao on 12-12-6.
//  Copyright (c) 2012年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BridgeInstanceProtocol <NSObject>

-(NSDictionary*) getInstanceContext;

@end

@interface TopBridgeWebview : UIWebView<UIWebViewDelegate>

@property(assign,nonatomic) id<BridgeInstanceProtocol> brigedelegate;
@property(copy,nonatomic) NSDictionary* subParameters;

-(void) bridgeEnable:(bool) enable;


+ (void)addObserver:(id)observer selector:(SEL)aSelector oncall:(NSString*) methodName;

+ (void)removeObserverForCall:(NSString*) methodName;


@end
