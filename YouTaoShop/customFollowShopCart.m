//
//  customFollowShopCart.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-26.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "customFollowShopCart.h"
#import "ASIHTTPRequest.h"
#import "TopIOSClient.h"
#import "taobaoData.h"
#import "taobaoUtil.h"
#import "FilterTaobaoTaobaoProduct.h"

#define TAOBAO_SCLICK_SEARCH_URL          @"http://r.m.taobao.com/s?p=mm_43457538_4062176_13210794&q="

//海波的阿里妈妈账号
//http://r.m.taobao.com/s?p=mm_44302110_4086475_13314050&q=

//宋燕的阿里妈妈账号
//http://r.m.taobao.com/s?p=mm_10835765_4088415_13310838&q=


#define PARSE_PRODUCTS_INGORE_SEPARATE                  @" "
#define PARSE_PRODUCTS_SHOP_SEPARATE                    @"\t"
#define PARSE_PRODUCTS_PRODUCTS_SEPARATE                @"-*-"

#define GET_WEB_LISTDATA_INTERVAL       0.5
#define MAX_GET_LIST_COUNT              11

#define LocalWebTag             101
#define TabAllWebTag            503
#define FollowOrderWebTag       1005


@implementation customFollowShopCart
{
    NSMutableArray *webViewArray;
    
    //不精准淘宝订单产生时间，用于用户获取返利时和阿里妈妈后台对账
    NSString *orderTime;
    
    uint repeatGetListCount;
    
    uint failedGetSClickCount;
    uint succeedGetSClickCount;
}

+ (NSString *)getOrderFanliInfo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = nil;
    if(paths && paths.count){
        path = [paths objectAtIndex:0];
    }
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", path, kFanliFileName];
    
    NSDictionary *diskDic = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        diskDic = [NSMutableDictionary dictionaryWithContentsOfFile:fullPath];
        //diskDic = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    }else{
        return nil;
    }
    
    return [diskDic description];
}

+ (void)resetFanliInfo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = nil;
    if(paths && paths.count){
        path = [paths objectAtIndex:0];
    }
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", path, kFanliFileName];
    NSDictionary *diskDic = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        diskDic = [NSMutableDictionary dictionaryWithContentsOfFile:fullPath];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserFanliCount object:nil];
    
    //NSArray *oldArray = [diskDic safeObjectForKey:kFanliArrayKey];
    //[[NSFileManager defaultManager] moveItemAtPath:fullPath toPath:nil error:nil];
    
    
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
}

#pragma mark - alloc && dealloc
- (id)init
{
    if (self = [super init]) {
        webViewArray = [[NSMutableArray alloc] init];
        _array = [[NSMutableArray alloc] init];
        _firstWebarray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)cancleDelayTask
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(WebViewLoadListItemSucceed:) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(WebViewLoadListItemSucceed:) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayDelegateFollowWebviewResult:) object:nil];
}

- (void)dealloc
{
    NSLog(@"customFollowShopCart dealloc ");
    [[SHKActivityIndicator currentIndicator] hidden];
    SAFE_RELEASE(webViewArray);
    SAFE_RELEASE(_array);
    SAFE_RELEASE(_firstWebarray);
    [super dealloc];
}

#pragma mark - 用户拿返利相关模块
- (void)addRecordOrderTimeListen:(UIWebView *)webView
{
    //貌似有时有效有时无效，故暂时废弃
    NSFileManager *manager=[NSFileManager defaultManager];
    NSString *jsPath=[FilterTaobaoTaobaoProduct dataFilePath:@"orderListen"];
    if (![manager fileExistsAtPath:jsPath]) {
        jsPath=[[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"orderListen"];
    }
    NSString *js=[NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    
    //增加监听事件
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)recordTime:(BOOL)type
{
    [self getTaobaoTimerError];
    [self recordFanliInfoToDisk:type];
    return;
}

+ (NSArray *)getFanliInfoToRefreshUI
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = nil;
    if(paths && paths.count){
        path = [paths objectAtIndex:0];
    }
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", path, kFanliFileName];
    
    NSMutableDictionary *diskDic = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        diskDic = [NSMutableDictionary dictionaryWithContentsOfFile:fullPath];
    }
    
    NSMutableArray *array = nil;
    if (!diskDic) {
        return nil;
    }else{
        array = [diskDic objectForKey:kFanliArrayKey];
        return array;
    }
    
    return nil;
}

+ (void)deleteItemInFanliInfoDisk:(NSArray *)deletePids
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = nil;
    if(paths && paths.count){
        path = [paths objectAtIndex:0];
    }
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", path, kFanliFileName];
    
    NSMutableDictionary *diskDic = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        diskDic = [NSMutableDictionary dictionaryWithContentsOfFile:fullPath];
    }
    
    if (!diskDic) {
        return;
    }
    
    NSMutableArray *NewTotalArray = [NSMutableArray arrayWithCapacity:5];
    NSArray *array= [diskDic objectForKey:kFanliArrayKey];
    
    for (NSDictionary *dic in array) {
        
        NSMutableDictionary *targetDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSArray *pids = [targetDic objectForKey:kFanliInfo];
        NSMutableArray *targetPids = [NSMutableArray arrayWithCapacity:5];
        BOOL flag = NO;
        for (NSString *pid in pids) {
            for (NSString * dPid in deletePids) {
                if (![dPid isEqualToString:pid]) {
                    flag = YES;
                    [targetPids addObject:pid];
                }
            }
        }

        if (flag) {
            [targetDic setObject:targetPids forKey:kFanliInfo];
            [NewTotalArray addObject:targetDic];
        }
    }
    
    [diskDic setObject:NewTotalArray forKey:kFanliArrayKey];
    BOOL ret = [diskDic writeToFile:fullPath atomically:NO];
    NSLog(@"new diskDic write %d  content %@", ret, diskDic);
}

- (void)recordFanliInfoToDisk:(BOOL)isTaobaoSystemTime
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = nil;
    if(paths && paths.count){
        path = [paths objectAtIndex:0];
    }
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", path, kFanliFileName];
    
    NSMutableDictionary *diskDic = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        diskDic = [NSMutableDictionary dictionaryWithContentsOfFile:fullPath];
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    //只需要ID
    BOOL pidFlag = NO;
    NSMutableArray *diskArray = [NSMutableArray arrayWithCapacity:_array.count];
    for (NSDictionary *dic in _array) {
        NSString *sPid = [dic safeObjectForKey:kWProductId];
        if ([dic safeObjectForKey:kWProductSClick] && sPid.length > 3) {
            [diskArray addObject:sPid];
            pidFlag = YES;
        }
    }
    
    if (!pidFlag) {
        NSLog(@"user buy something,but these things no rebate or pid not exist,so ignore,not record");
        [[SHKActivityIndicator currentIndicator] hidden];
        [[SHKActivityIndicator currentIndicator] displayActivity:@"您没有购买/使用了标准版淘宝购买宝贝"];
        [[SHKActivityIndicator currentIndicator] hideAfterDelay:4.0];
        return;
    }
    
    [dic setObject:diskArray forKey:kFanliInfo];
    [dic setObject:_taobaoTime forKey:kFanliOrderTime];
    
    if (isTaobaoSystemTime) {
        [dic setObject:@"ailiPaybuttonTimer" forKey:kFanliTimeType];
    }else{
        [dic setObject:@"aliPayWebPageTimer" forKey:kFanliTimeType];
    }
    
    NSMutableArray *array = nil;
    if (!diskDic) {
        diskDic = [NSMutableDictionary dictionaryWithCapacity:1];
        array = [NSMutableArray arrayWithCapacity:1];
    }else{
        array = [diskDic objectForKey:kFanliArrayKey];
    }
    
    [array addObject:dic];
    NSLog(@"array %@", array);
    [diskDic setObject:array forKey:kFanliArrayKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserFanliCount object:array];
    
    BOOL ret = [diskDic writeToFile:fullPath atomically:NO];
    NSLog(@"diskDic write %d  content %@", ret, diskDic);
}

- (void)getTaobaoTimerError
{
    NSLog(@"get taobao system time error,so use local time");
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    self.taobaoTime = [dateformatter stringFromDate:senddate];
}


#pragma mark - 根据JS脚本生成需要淘宝对象结构

- (void)jsErrorAlert
{
    [[SHKActivityIndicator currentIndicator] hidden];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网页出现错误" message:@"为了不丢失您的订单，请重新进入购物车页面，否则有可能无法获得相关商品的返利" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}


- (void)parseNewProductsStringToArray:(NSString *)productsString pids:(NSString *)pids
{
    SAFE_INSTANCE_CHECK(productsString)
    NSLog(@"-------productsString %@ \n-------pids %@", productsString, pids);
    
    NSArray *array = [productsString componentsSeparatedByString:PARSE_PRODUCTS_PRODUCTS_SEPARATE];
    NSArray *pidsArray = [pids componentsSeparatedByString:PARSE_PRODUCTS_PRODUCTS_SEPARATE];
    
    for (int i = 0; i < pidsArray.count; i++) {
    
        NSString *pid = [pidsArray objectAtIndex:i];
        NSString *name = [array objectAtIndex:i];
        if ([pid isEqualToString:name]) {
            if ([pid isEqualToString:@"undefined"]) {
                [MobClick event:@"jsStringError:pid==name==undefined"];
            }else{
                [MobClick event:@"jsStringError:pid==name&&pid!=undefined"];
                [self jsErrorAlert];
                return;
            }
        }else if (pid.length < 4){
            [MobClick event:@"jsStringError:pid.length<4"];
            [self jsErrorAlert];
            return;
        }else if (name.length < 4){
            [MobClick event:@"jsStringError:name.length<4"];
            [self jsErrorAlert];
            return;
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
        [dic setObject:pid forKey:kWProductId];
        [dic setObject:name forKey:kWProductName];
        
        [_array addObject:dic];
    }
    
    NSLog(@"taobao products array count %d is %@", _array.count, _array);
    [self startGetTaobaoSclick];
}

- (void)parseProductsStringToArray:(NSString *)productsString
{
    SAFE_INSTANCE_CHECK(productsString)
    NSLog(@"productsString %@", productsString);
    
    NSArray *array = [productsString componentsSeparatedByString:PARSE_PRODUCTS_SHOP_SEPARATE];
    
    for (NSString *string in array) {
        NSArray *childArray = [string componentsSeparatedByString:PARSE_PRODUCTS_PRODUCTS_SEPARATE];
        NSLog(@"js string %@ array %@", string, childArray);
        //here must be protectting
        if (!childArray || (childArray.count < 2)) {
            NSLog(@"js date error");
            return;
        }
        
        NSString *productId = [childArray objectAtIndex:0];
        NSString *productTitle = [childArray objectAtIndex:1];
        
        if (childArray.count > 2) {
            for (int i = 2; i < childArray.count; i++) {
                productTitle = [NSString stringWithFormat:@"%@-%@", productTitle, [childArray objectAtIndex:i]];
            }
        }
        //NSString *productShopName = [childArray objectAtIndex:2];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
        [dic setObject:productId forKey:kWProductId];
        [dic setObject:productTitle forKey:kWProductName];
        
        [_array addObject:dic];
    }
    
    NSLog(@"taobao products array count %d is %@", _array.count, _array);
    [self startGetTaobaoSclick];
}

#pragma mark - name deal

- (NSString *)nameSearchOptimize:(NSString *)name
{
    if (name.length < 16) {
        return name;
    }
    
    NSArray *childNameArray = [name componentsSeparatedByString:@" "];
    NSString *optimizeName = nil;
    int length = 0;
    for (NSString *keyName in childNameArray) {
        if (keyName.length > length) {
            length = keyName.length;
            if (keyName.length > 10) {
                optimizeName = keyName;
            }
        }
    }
    
    if (!optimizeName) {
        return name;
    }
    
    return optimizeName;
}

#pragma mark - custom sclick

- (void)startGetTaobaoSclick
{
    if (!_array) {
        NSLog(@"no date need to get taobao  sclick");
        return;
    }
    
    for (NSDictionary *dic in _array) {
        NSString *name = [dic objectForKey:kWProductName];
        NSURL *url = nil;
        NSString *optimizeName = [self nameSearchOptimize:name];
        NSLog(@"optimizeName %@", optimizeName);
        NSString *string = [NSString stringWithFormat:@"%@%@", TAOBAO_SCLICK_SEARCH_URL, optimizeName];
        //全英文无问题
        url = [NSURL URLWithString:[string
                                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        UIWebView *webview = [[[UIWebView alloc] init] autorelease];
        [_firstWebarray addObject:webview];
        webview.delegate = self;
        webview.tag = LocalWebTag;
        [webview loadRequest:[NSURLRequest requestWithURL:url]];

    }
}

- (void)getSClickByWebview:(UIWebView *)webView
{
    //(document.getElementsByClassName('J_PreviewArrow')).length
    
    //(document.getElementsByClassName('J_PreviewArrow'))[0].getAttribute('dataid')
    //(document.getElementsByClassName('J_PreviewArrow'))[0].getAttribute('dataww')
    //(document.getElementsByClassName('list-item'))[0].getElementsByTagName('a')[1].href
    //(document.getElementsByClassName('list-item'))[0].getElementsByTagName('a')[1].innerText
    
    BOOL ret = NO;
    NSString *listCountString = [webView stringByEvaluatingJavaScriptFromString:@"(document.getElementsByClassName('J_PreviewArrow')).length"];
    NSLog(@"webView search list count %d", listCountString.intValue);
    
    //二期考虑做SClick缓存
    
    for (int i = 0; i < listCountString.intValue; i++) {
        if (ret) {
            break;
        }
        NSString *webPid = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"(document.getElementsByClassName('J_PreviewArrow'))[%d].getAttribute('dataid')", i]];
        NSString *sClick = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"(document.getElementsByClassName('list-item'))[%d].getElementsByTagName('a')[1].href", i]];
        NSLog(@"js get pid %@ sclick %@", webPid, sClick);
        for (NSMutableDictionary *dic in _array) {
            NSString *pid = [dic objectForKey:kWProductId];
            if ([pid isEqualToString:webPid]) {
                [dic setObject:sClick forKey:kWProductSClick];
                ret = YES;
                break;
            }
        }
    }
    
    if (ret) {
        succeedGetSClickCount++;
    }else{
        failedGetSClickCount++;
    }
    
    if (succeedGetSClickCount+failedGetSClickCount == _array.count) {
        if ([_delegate respondsToSelector:@selector(SClickResultComeBack:failedCount:)]) {
            [_delegate SClickResultComeBack:succeedGetSClickCount failedCount:failedGetSClickCount];
        }
        [self startToFollowTaobaoProduct];
    }
}

#pragma mark - start follow taobao product

- (void)startToFollowTaobaoProduct
{
    NSLog(@"_array update %@", _array);
    for (NSDictionary *dic in _array) {
        NSString *sClick = [dic safeObjectForKey:kWProductSClick];
        if (!sClick) {
            NSLog(@"pid %@ have no sclick", [dic safeObjectForKey:kWProductId]);
        }else{
            NSURL *url = [NSURL URLWithString:sClick];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            UIWebView *webView = [[[UIWebView alloc] init] autorelease];
            webView.delegate = self;
            webView.tag = FollowOrderWebTag;
            [webViewArray addObject:webView];
            [webView loadRequest:request];
        }
    }
}

#pragma mark - webview delegate

- (void)delayDelegateFollowWebviewResult:(UIWebView *)webView
{
    if ([_delegate respondsToSelector:@selector(WebViewSClickLoadResult:)]) {
        [_delegate WebViewSClickLoadResult:YES];
    }
}

- (void)WebViewLoadListItemSucceed:(UIWebView *)webView
{
    NSString *listCountString = [webView stringByEvaluatingJavaScriptFromString:@"(document.getElementsByClassName('J_PreviewArrow')).length"];
    if ((!listCountString || listCountString.intValue < 6) && ((webView.tag - 1 - TabAllWebTag)< MAX_GET_LIST_COUNT*2)) {
        NSLog(@"webView %@ list data %d have not get succeed,so waiting %f second", webView, webView.tag, GET_WEB_LISTDATA_INTERVAL);
        webView.tag++;
        [self performSelector:@selector(WebViewLoadListItemSucceed:) withObject:webView afterDelay:GET_WEB_LISTDATA_INTERVAL];
    }else{
        [self getSClickByWebview:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.tag == TabAllWebTag) {
        webView.tag = TabAllWebTag + 1;
        [self performSelector:@selector(WebViewLoadListItemSucceed:) withObject:webView afterDelay:GET_WEB_LISTDATA_INTERVAL*2];
        return;
    }
    
    else if (webView.tag == LocalWebTag) {
        
        //因为 无线淘宝某些关键字搜索会搜索到促销分类里去，故此处将他改为 搜索全部
        NSString *urlString = [[[webView request] URL] absoluteString];
        
        //It looks unneed
        //if([urlString hasPrefix:@"http://s8.m.taobao.com/munion/search.htm"])
        {
            NSString *newStringUrl = [NSString stringWithFormat:@"%@tab=all", urlString];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newStringUrl]]];
            webView.tag = TabAllWebTag;
        }
    }
    
    else if (webView.tag == FollowOrderWebTag) {
        webView.tag = FollowOrderWebTag+1;
        NSLog(@"webView follow ok first %@", webView);
        [self performSelector:@selector(delayDelegateFollowWebviewResult:) withObject:webView afterDelay:2];
    }else{
        NSLog(@"default webview %@ didfinish load", webView);
    }
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView.tag == FollowOrderWebTag) {
        webView.tag = 0;
        succeedGetSClickCount--;
        failedGetSClickCount++;
        
        if ([_delegate respondsToSelector:@selector(WebViewSClickLoadResult:)]) {
            [_delegate WebViewSClickLoadResult:NO];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"因为网络原因，跟单失败，请重新进入购物车尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [MobClick event:@"followOrderNetError"];
    }
}

@end
