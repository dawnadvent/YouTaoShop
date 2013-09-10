//
//  ErrorProtectCateGory.h
//  Fanli
//
//  Created by jiangwei.wu on 13-4-17.
//  Copyright (c) 2013年 mxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (ErrorProtectMDicCateGory)

-(NSString *)stringByAppendingString:(NSString *)aString;

-(id)safeObjectForKey:(NSString *)aKey;

@end

@interface NSDictionary (ErrorProtectDicCateGory)

-(NSString *)stringByAppendingString:(NSString *)aString;

-(id)safeObjectForKey:(NSString *)aKey;

@end

@interface NSUserDefaults (ErrorProtectUserDCateGory)

-(id)safeObjectForKey:(NSString *)aKey;

@end

@interface NSString (ErrorProtectNSStringCateGory)

+ (id)safeStringWithString:(NSString *)string;
-(NSString *)EncodeString;
-(NSString *)DecodedString;

@end
