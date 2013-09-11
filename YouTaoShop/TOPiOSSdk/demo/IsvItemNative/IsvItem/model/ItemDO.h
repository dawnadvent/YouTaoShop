//
//  ItemDO.h
//  IsvItem
//
//  Created by tianqiao on 12-11-24.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemDO : NSObject

@property (nonatomic,copy) NSString * itemTitle;
@property (nonatomic,copy) NSString * itemImageUrl;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * itemId;
@property (nonatomic,copy) NSString * props;
@property (nonatomic,copy) NSString * cid;
@property (nonatomic,copy) NSString * num;

+(id)initOnsaleList;

+(id)initAllList;
+(id)initObject :(NSString*) itemId;
+(ItemDO *) initObjectByDictionary:(NSDictionary *)json;
+(NSString *) addObject:(ItemDO*) item;
+(NSString *) editObject:(ItemDO*) item;
@end
