//
//  ErrorProtectCateGory.m
//  Fanli
//
//  Created by jiangwei.wu on 13-4-17.
//  Copyright (c) 2013年 mxy. All rights reserved.
//

#import "ErrorProtectCateGory.h"

@implementation NSMutableDictionary (ErrorProtectMDicCateGory)

-(NSString *)stringByAppendingString:(NSString *)aString
{
    //wujiangwei error
    NSLog(@"wujiangwei error NSMutableDictionary stringByAppendingString :%@", aString);
    return aString;
}

-(id)safeObjectForKey:(NSString *)aKey
{
    id object = [self objectForKey:aKey];
    
    if (object == [NSNull null]) {
        object = nil;
    }
    
    return object;
}

@end

@implementation NSDictionary (ErrorProtectDicCateGory)

-(NSString *)stringByAppendingString:(NSString *)aString
{
    //wujiangwei error
    NSLog(@"wujiangwei error NSDictionary stringByAppendingString :%@", aString);
    return aString;
}

-(id)safeObjectForKey:(NSString *)aKey
{
    id object = [self objectForKey:aKey];
    
    if (object == [NSNull null]) {
        object = nil;
    }
    
    return object;
}

@end

@implementation NSUserDefaults (ErrorProtectUserDCateGory)

-(id)safeObjectForKey:(NSString *)aKey
{
    return [self objectForKey:aKey];
}

@end

@implementation NSString (ErrorProtectNSStringCateGory)

+ (id)safeStringWithString:(NSString *)string
{
    if (!string) {
        return @"";
    }
    
    return [NSString stringWithString:string];
}


-(NSString *)EncodeString
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    [result release];
    return result;
}

-(NSString *)DecodedString
{
    NSString *resultString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
    return [resultString autorelease];
}

@end
