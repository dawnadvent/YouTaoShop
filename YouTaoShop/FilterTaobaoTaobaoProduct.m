//
//  FilterTaobaoTaobaoProduct.m
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-29.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "FilterTaobaoTaobaoProduct.h"

@implementation FilterTaobaoTaobaoProduct

+ (NSString *)dataFilePath:(NSString *)fileName{
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths1 objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (NSArray *)getFilterCid {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *cidsPath=[FilterTaobaoTaobaoProduct dataFilePath:@"cidfilter"];
    if (![manager fileExistsAtPath:cidsPath]) {
        cidsPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"cidfilter"];
    }
    NSString *cids = [NSString stringWithContentsOfFile:cidsPath encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *cidsSplit = [cids componentsSeparatedByString:@","];
    return cidsSplit;
}

@end
