//
//  taobaoUtil.m
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-29.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "taobaoUtil.h"
#import "FilterTaobaoTaobaoProduct.h"
#import "customFollowShopCart.h"

#define kTaobaoRulesFilename @"taobaorules.plist"

NSDictionary *regexDic = nil;

@implementation taobaoUtil

//unicode编码以\u开头
+(NSString *)utf8ToUnicode:(NSString *)string
{
    
    NSUInteger length = [string length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
    {
        unichar _char = [string characterAtIndex:i];
        
        //判断是否为英文和数字
        
        if (_char <= '9' && _char >= '0')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
        else if(_char >= 'a' && _char <= 'z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]]; 
        }
        else if(_char >= 'A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
        else
        {
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }
    }
    
    return s;
    
}

+ (NSString *)getTaobaoIdWithUrlReg:(NSString *)url Reg:(NSString *)Reg{
    NSError *error;
    
    //http+:[^\\s]* 这是检测网址的正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:Reg options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:url options:0 range:NSMakeRange(0, [url length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            //从urlString中截取数据
            NSString *result = [url substringWithRange:resultRange];
            //NSLog(@"%@",result);
            NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
            if (regex2 != nil) {
                NSTextCheckingResult *secondMatch = [regex2 firstMatchInString:result options:0 range:NSMakeRange(0, [result length])];
                if (secondMatch) {
                    NSRange resultRange2 = [secondMatch rangeAtIndex:0];
                    //从urlString中截取数据
                    NSString *result2 = [result substringWithRange:resultRange2];
                    
                    return  result2;
                    
                }
            }
        }
        
    }
    return nil;
}

+ (NSString *)getTaobaoIdWithDic:(NSString *)url{
    
    regexDic = [NSDictionary dictionaryWithContentsOfFile:[FilterTaobaoTaobaoProduct dataFilePath:kTaobaoRulesFilename]];
    if (!regexDic) {
        //http://a.m.taobao.com/i18236443842.htm?scm=0.0.0.0
        //http://item.taobao.com/item.htm?id=222222222
        NSString *path = [[NSBundle mainBundle] pathForResource:@"taobaorules" ofType:@"plist"];
        regexDic = [NSDictionary dictionaryWithContentsOfFile:path];
        if (!regexDic) {
            NSArray *a1=[NSArray arrayWithObjects:@"/i(\\d+)\\.htm", nil];
            NSArray *a2=[NSArray arrayWithObjects:@"/i(\\d+)\\.htm", nil];
            NSArray *a3=[NSArray arrayWithObjects:@"item_id=(\\d+)", nil];
            NSArray *a4=[NSArray arrayWithObjects:@"/id=(\\d+)", nil];
            regexDic=[NSDictionary dictionaryWithObjectsAndKeys:a1,@"a.m.taobao.com",a2,@"a.m.tmall.com",a3,@"ju.taobao.com",a4, @"item.taobao.com",nil];
            [regexDic writeToFile:[FilterTaobaoTaobaoProduct dataFilePath:kTaobaoRulesFilename] atomically:YES];
        }
    }
    //NSLog(@"regexDic %@", regexDic);
    NSString *pid=nil;
    NSEnumerator *enumerator = [regexDic keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        if (![key isEqualToString:@""]) {
            if ([url hasPrefix:[NSString stringWithFormat:@"http://%@",key]]) {
                NSArray *regArray=[regexDic safeObjectForKey:key];
                for (int i=0; i<regArray.count; i++) {
                    pid=[self getTaobaoIdWithUrlReg:url Reg:[regArray objectAtIndex:i]];
                    if (pid) {
                        break;
                    }
                }
                
                if (pid) {
                    break;
                }
            }
        }
    }
    
    return pid;
    
}

@end
