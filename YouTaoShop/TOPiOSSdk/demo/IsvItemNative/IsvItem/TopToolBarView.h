//
//  ToolBarView.h
//  TopTooBar
//
//  Created by lihao on 12-11-25.
//  Copyright (c) 2012年 lihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopToolBarView : UIView<UIWebViewDelegate>

-(void) on:(NSString*) event
        call:(void (^)(NSDictionary* data))completion;

@end
