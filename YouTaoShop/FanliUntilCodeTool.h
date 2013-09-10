//
//  FanliUntilCodeTool.h
//  Fanli
//
//  Created by jiangwei.wu on 13-4-11.
//  Copyright (c) 2013年 mxy. All rights reserved.
//


#define INVALIDED_URL_NUMBER    -1

#define SAFE_RELEASE(instanse)  [instanse release], instanse = nil

#define SAFE_INSTANCE_CHECK_RETURN(instanse, returnValue)    if(!(instanse)) {return returnValue;}

#define SAFE_INSTANCE_CHECK(instanse)    if(!(instanse)) {return;}

#define GET_SYSTEM_EXACTLY_TIME 

#define iphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)