//
//  taobaoFollowShopCartUntil.m
//  Fanli
//
//  Created by jiangwei.wu on 13-4-11.
//  Copyright (c) 2013年 mxy. All rights reserved.
//

#import "taobaoFollowShopCartUntil.h"
#import "taobaoData.h"

#import "AppUtil.h"
#import "taobaoTrackObject.h"

#import "FilterTaobaoTaobaoProduct.h"

#import "ASIHTTPRequest.h"

#define MAX_NUMBER_IN_TAOBAO_SHOPCART   40            //need comfirm

#define SINGLE_DEAL_TAOBAO_WEBVIEW_TAG  1

#define LOAD_WEBVIEW_INTERVAL           0.2

#define COOKIE_WEBVIEW_MAXLOAD_TIME     30
#define DELAY_RELEASE_COOKIE_WEBVIEW    0.1

#define M_TAOBAO_PRODUCT_HEAD                           @"http://a.m.taobao.com/i%@.htm"

#define PARSE_PRODUCTS_INGORE_SEPARATE                  @" "
#define PARSE_PRODUCTS_SHOP_SEPARATE                    @"\t"
#define PARSE_PRODUCTS_PRODUCTS_SEPARATE                @"-*-"


#pragma mark - CookieWebView .m
@implementation CookieWebView

@synthesize taobaoProductId;

-(void)safedealloc
{
    [taobaoProductId release];
    [super dealloc];
}

-(void)dealloc
{
    //必须在主线程释放，不然会crash
    [self performSelectorOnMainThread:@selector(safedealloc) withObject:nil waitUntilDone:NO];
}

@end

#pragma mark -taobao shop data TaoBaoShopDataObject .m
@implementation TaoBaoShopDataObject

@synthesize shopName;
@synthesize shopProductIds;

-(id)init
{
    if (self=[super init]) {
        shopProductIds=[[NSMutableArray alloc] init];
        
    }
    
    return self;
}

-(void)addProductIdToShop:(NSString *)pid
{
    SAFE_INSTANCE_CHECK(pid)
    NSLog(@"pid %@", pid);
    if(![taobaoFollowShopCartUntil didStringObjectExist:pid InArray:shopProductIds])
    {
        [shopProductIds addObject:pid];
    }
}

-(void)dealloc
{
    SAFE_RELEASE(shopName);
    SAFE_RELEASE(shopProductIds);
    
    [super dealloc];
}

@end

#pragma mark - taobaoFollowShopCartUntil.m

@implementation taobaoFollowShopCartUntil
{
    CookieWebView *webViewArray[MAX_NUMBER_IN_TAOBAO_SHOPCART];
    
    uint nofanliNum;
    
    uint needTaokeInfoCount;
    
    //unused
    uint noCidfanliProductNum;
    uint taobaoCidArrayIndex;
    uint taobaoSClickArrayIndex;
}

@synthesize delegate=_delegate;

@synthesize taobaoProductObjects=_taobaoProductObjects;

@synthesize loadFailProductWebViewIds=_loadFailProductWebViewIds;
@synthesize loadedProductWebViewIds=_loadedProductWebViewIds;

+(BOOL)didStringObjectExist:(NSString *)checkTaobaoProductId InArray:(NSArray *)array
{
    SAFE_INSTANCE_CHECK_RETURN(checkTaobaoProductId, NO)
    SAFE_INSTANCE_CHECK_RETURN(array, NO)
    
    for (NSString *linkedId in array) {
        if ([linkedId isEqualToString:checkTaobaoProductId]) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - instance methrod

-(id)initWithNewJSString:(NSString *)jsString withShopNameString:(NSString *)shopNameString withTc:(NSString *)tc isAutoExcute:(BOOL)isAuto  delegate:(id)delegate
{
    if (self=[super init]) {
        _loadedProductWebViewIds=[[NSMutableArray alloc] init];
        _taobaoProductObjects=[[NSMutableArray alloc] init];
        _loadFailProductWebViewIds =[[NSMutableArray alloc] init];
        _needfollowedProductUrls = [[NSMutableArray alloc] init];
        
        [self parseNewProductsStringToArray:jsString shopNameString:shopNameString];
        
        _delegate = delegate;
        
        if (isAuto) {
            [self generateNeedFollowedProductIdArrays];
        }
        
    }
    
    return self;
}

-(id)initWithJSString:(NSString *)jsString withTc:(NSString *)tc isAutoExcute:(BOOL)isAuto  delegate:(id)delegate
{
    if (self=[super init]) {
        _loadedProductWebViewIds=[[NSMutableArray alloc] init];
        _taobaoProductObjects=[[NSMutableArray alloc] init];
        _loadFailProductWebViewIds =[[NSMutableArray alloc] init];
        _needfollowedProductUrls = [[NSMutableArray alloc] init];
        [self parseProductsStringToArray:jsString];
        
        _delegate = delegate;
        
        if (isAuto) {
            [self generateNeedFollowedProductIdArrays];
        }
        
    }
    
    return self;
}

-(void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    for (int i=0; i < _taobaoProductObjects.count; i++) {
        SAFE_RELEASE(webViewArray[i]);
    }
    
    _delegate=nil;
    
    SAFE_RELEASE(_loadedProductWebViewIds);
    SAFE_RELEASE(_taobaoProductObjects);
    SAFE_RELEASE(_loadFailProductWebViewIds);
    
    [super dealloc];
}

+ (NSString *)didTidSClickUrlExist:(NSNumber *)tid
{
    NSMutableDictionary *removeDic = nil;
    
    for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
        NSNumber *dTid = [dic objectForKey:@"num_iid"];
        if (dTid.longLongValue == tid.longLongValue) {
            
            NSString *oldDate = [dic objectForKey:@"date"];
            if(![AppUtil isTimeExpire:oldDate timeE:[AppUtil GetCurTime]])
            {
                NSString *shop_click_url = [dic objectForKey:@"shop_click_url"];
                NSLog(@"exist shop_click_url is %@", shop_click_url);
                return shop_click_url;
            }else
            {
                removeDic = dic;
            }
            break;
        }
    }
    
    if (removeDic) {
        [[taobaoTrackObject sharedInstance] removeObject:nil];
    }
    
    return nil;
}

#pragma mark - get need taobao info from object

-(NSString *)getShopNameByTid:(NSString *)tid
{
    for (TaoBaoShopDataObject *taobaoObject in _taobaoProductObjects) {
        
        for (NSString *productId in taobaoObject.shopProductIds) {
            if ([productId isEqualToString:tid]) {
                return taobaoObject.shopName;
            }
        }
    }
    
    return nil;
}

-(NSDictionary *)getTaobaokeInfoByTid:(NSNumber *)tid
{
    for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
        NSNumber *dTid = [dic objectForKey:@"num_iid"];
        if (dTid.longLongValue == tid.longLongValue) {
            
            return dic;
        }
    }
    
    return nil;
}

#pragma mark - taobao api

-(void)sendTaobaokeWithArray:(NSArray *)tids
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    NSMutableString *arrayString = [[NSMutableString alloc] init];
    
    int flag = 0;
    
    for (NSString *tid in tids) {
        if (!flag) {
            [arrayString appendFormat:@"%@", tid];
        }else
            [arrayString appendFormat:@",%@", tid];
        flag ++;
    }
    
    if (!arrayString.length) {
        [params release];
        [arrayString release];
        return;
    }
    
    [params setObject:@"taobao.taobaoke.widget.items.convert" forKey:@"method"];
    [params setObject:@"shop_click_url,\
                            nick,seller_credit_score,\
                            num_iid,\
                                title,pic_url,price,promotion_price,commission,commission_rate,click_url" forKey:@"fields"];
    NSLog(@"old arrayString %@",arrayString);
    [params setObject:arrayString forKey:@"num_iids"];
    [params setObject:@"true" forKey:@"is_mobile"];
    TopIOSClient *iosClient =[TopIOSClient getIOSClientByAppKey:kTaobaoKey];
    
    [iosClient api:@"POST" params:params target:self cb:@selector(fanliResponse:) userId:@""needMainThreadCallBack:true];
    [params release];
    [arrayString release];
}

#pragma mark - add taobaoke info to single instance

-(void)fanliResponse:(id)data
{
    if ([data isKindOfClass:[TopApiResponse class]])
    {
        TopApiResponse *response = (TopApiResponse *)data;
        if ([response content])
        {
            NSDictionary *dic=(NSDictionary *)[[response content] JSONValue];
            NSLog(@"dic %@", dic);
            NSDictionary *dic1=[dic objectForKey:@"taobaoke_widget_items_convert_response"];
            NSDictionary *dic2=[dic1 objectForKey:@"taobaoke_items"];
            NSArray *array =[dic2 objectForKey:@"taobaoke_item"];
            
            for (NSDictionary *taobaokeDic in array) {
                //NSNumber *taobaoId = [taobaokeDic objectForKey:@"num_iid"];
                //NSString *taobaoS = [NSString stringWithFormat:@"%lld", taobaoId.longLongValue];
                //NSLog(@"array .count %@", array);
                [taobaoTrackObject AddTaobaokeInfoToSInstance:taobaokeDic];
                
                [self performSelector:@selector(asyncCallDelegate:) withObject:taobaokeDic];

            }
            
            if (array.count < needTaokeInfoCount) {
                for (int ii = 0; ii < needTaokeInfoCount - array.count; ii++) {
                    if (_delegate && [_delegate respondsToSelector:@selector(WebViewGetTaobaokeInfoFailed)]) {
                        [_delegate WebViewGetTaobaokeInfoFailed];
                    }
                }
            }
        }
        else {
            if (_delegate && [_delegate respondsToSelector:@selector(WebViewGetTaobaokeInfoFailed)]) {
                [_delegate WebViewGetTaobaokeInfoFailed];
            }
        }
    }else{
        if(_delegate && [_delegate respondsToSelector:@selector(WebViewGetTaobaokeInfoFailed)]) {
            [_delegate WebViewGetTaobaokeInfoFailed];
        }
    }
    
    [self startFollowProduct];
}


#pragma mark - 根据ID生成淘宝的商品链接

//get taobao url by taobao id
+(NSString *)getTaobaoUrlByProductId:(NSString *)productId
{
    return [NSString stringWithFormat:M_TAOBAO_PRODUCT_HEAD, productId];
}

#pragma mark - 根据JS脚本生成需要淘宝对象结构

- (void)parseShopAndProductString:(NSString *)parsedString
{
    //the format of parsedString must be 17787602792-京衣Fashion-shop  productID-shopName,allow PARSE_PRODUCTS_INGORE_SEPARATE anywhere
    
    TaoBaoShopDataObject *taobaoShopObject=[[TaoBaoShopDataObject alloc] init];
    
    NSRange range=[parsedString rangeOfString:PARSE_PRODUCTS_PRODUCTS_SEPARATE];
    
    NSLog(@"product id %@ shop name %@", [parsedString substringToIndex:range.location], [parsedString substringFromIndex:range.location]);
    [taobaoShopObject addProductIdToShop:[parsedString substringToIndex:range.location]];
    taobaoShopObject.shopName=[parsedString substringFromIndex:range.location + 1];
    
    [_taobaoProductObjects addObject:taobaoShopObject];
    SAFE_RELEASE(taobaoShopObject);
}

/*
 prase products of string to products of array
 if isAuto is YES,well do the follow-up jop itself, this time, tc must not be nil!!!!!
 */
-(NSArray *)parseProductsStringToArray:(NSString *)productsString
{
    SAFE_INSTANCE_CHECK_RETURN(productsString, nil)
    NSLog(@"productsString %@", productsString);
    
    NSMutableString *shopAndTaobaoString=nil;
    
    for (int i=0; i < productsString.length; i++) {
        NSRange range={i, 1};
        NSString *aS=[productsString substringWithRange:range];
        if ([aS isEqualToString:PARSE_PRODUCTS_INGORE_SEPARATE]) {
            //ignore " "
        }
        else if (![aS isEqualToString:PARSE_PRODUCTS_SHOP_SEPARATE]) {
            if (!shopAndTaobaoString) {
                shopAndTaobaoString=[[NSMutableString alloc] init];
            }
            [shopAndTaobaoString appendString:aS];
        }else
        {
            if (shopAndTaobaoString) {
                //parse shop name add product id,add product id to object if it not exist
                [self parseShopAndProductString:shopAndTaobaoString];
            }
            SAFE_RELEASE(shopAndTaobaoString);
        }
    }
    
    if (shopAndTaobaoString && ![shopAndTaobaoString isEqualToString:PARSE_PRODUCTS_SHOP_SEPARATE]) {
        [self parseShopAndProductString:shopAndTaobaoString];
    }
    
    SAFE_RELEASE(shopAndTaobaoString);
    
    NSLog(@"taobao products array count %d is %@", _taobaoProductObjects.count, _taobaoProductObjects);
    
    for (TaoBaoShopDataObject *taobao in _taobaoProductObjects) {
        NSLog(@"shop name %@, product ids %@", taobao.shopName, taobao.shopProductIds);
    }
    
    return _taobaoProductObjects;
}

-(NSArray *)parseNewProductsStringToArray:(NSString *)productsString shopNameString:(NSString *)shopNameString
{
    SAFE_INSTANCE_CHECK_RETURN(productsString, nil)
    NSLog(@"productsString %@", productsString);
    
    if (productsString.length < 4) {
        return nil;
    }
    
    NSArray *array = [productsString componentsSeparatedByString:PARSE_PRODUCTS_PRODUCTS_SEPARATE];
    NSArray *shopArray = [shopNameString componentsSeparatedByString:PARSE_PRODUCTS_PRODUCTS_SEPARATE];
    for (int i = 0; i < array.count; i++) {
        NSString *string = [array objectAtIndex:i];
        if ([string isEqualToString:@"undefined"]) {
            continue;
        }
        TaoBaoShopDataObject *taobaoShopObject=[[TaoBaoShopDataObject alloc] init];
        [taobaoShopObject addProductIdToShop:[array objectAtIndex:i]];
        taobaoShopObject.shopName = [shopArray objectAtIndex:i];
        
        [_taobaoProductObjects addObject:taobaoShopObject];
        [taobaoShopObject release];
    }
    
    NSLog(@"new taobao products array count %d is %@", _taobaoProductObjects.count, _taobaoProductObjects);
    
    for (TaoBaoShopDataObject *taobao in _taobaoProductObjects) {
        NSLog(@"new shop name %@, product ids %@", taobao.shopName, taobao.shopProductIds);
    }
    
    return _taobaoProductObjects;
}



#pragma mark - 生成需要跟单的淘宝ID

//generate follow urls by products of taobao ids
-(void)generateNeedFollowedProductIdArrays
{
    SAFE_INSTANCE_CHECK(_taobaoProductObjects)
    //here requst the url of fanli by product ids of taobao
    
    NSMutableArray *needGetTaobaokeInfoArray = [NSMutableArray arrayWithCapacity:4];
    
    for (TaoBaoShopDataObject *taobaoObject in _taobaoProductObjects) {
        //统一获取还没有淘宝客信息的宝贝
        for (NSString *productId in taobaoObject.shopProductIds) {
            NSNumberFormatter *numFM = [[[NSNumberFormatter alloc] init] autorelease];
            NSNumber *num_iid = [numFM numberFromString:productId];
            if (![self didTidExistIntaobaoTrackObject:num_iid]) {
                //[self getTaobaoCid:productId];
                [needGetTaobaokeInfoArray addObject:productId];
            }
        }
    }
    needTaokeInfoCount = needGetTaobaokeInfoArray.count;
    [self sendTaobaokeWithArray:needGetTaobaokeInfoArray];
}

#pragma mark -
#pragma mark 聚划算计算返利
- (void)getJuhuasuanFanli:(NSString *)pid
{
    //shopType = 2 淘宝商品
    
    NSString *getString =[NSString stringWithFormat:@"%@/api/search/getItemById?pid=%@&is_mobile=%i&shoptype=%i&%@",k51FanliRootUrl,pid,1,2,k51FanliAppendServices];
    ASIHTTPRequest* req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:getString]];
    [ASIHTTPRequest setSessionCookies:nil];
    [req setDelegate:self];
    [req startAsynchronous];
}

#pragma mark -
#pragma mark ASIHTTP request delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //仅仅支持 聚划算返利
    NSString *url=[[request url] absoluteString];
    NSLog(@"request url=%@",url);
    NSString *responseString = [request responseString];
    
    NSDictionary *dic=(NSDictionary *)[responseString JSONValue] ;
    NSLog(@"responseString==%@",dic);
    NSDictionary *dataDic=[dic safeObjectForKey:@"data"];
    if ([dataDic objectForKey:@"ju_commission_rate"]&&[dataDic objectForKey:@"ju_price"]) {
        NSString *rate=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"ju_commission_rate"]];
        float num=[rate floatValue];
        NSNumber *pid = [dic safeObjectForKey:@"pid"];
        NSLog(@"ju_commission_rate=%f",num);
        //NSString *ju_price=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"ju_price"]];
        //float p1=[ju_price floatValue];
        [taobaoTrackObject setProduct:pid CommissionRate:[dataDic objectForKey:@"ju_commission_rate"]];
        
    }else{
        //[self refreshFanliLable:@"暂无返利哦"];
        
    }
}

#pragma mark - 获取所有购买淘宝商品的淘宝客信息

- (BOOL)didTidExist:(NSString *)tid shopName:(NSString *)shopName
{
    NSMutableDictionary *removeDic = nil;
    
    for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
        NSString *num_id = [dic objectForKey:@"num_iid"];
        if ([num_id isEqualToString:tid]) {
            
            NSString *oldDate = [dic objectForKey:@"date"];
            if([AppUtil isTimeExpire:oldDate timeE:[AppUtil GetCurTime]])
            {
                //过期，更新数据
                removeDic = dic;
            }else
            {
                [self performSelector:@selector(asyncCallDelegate:) withObject:dic];
                
                return YES;
                
                //数据存在，无需再次请求
                /*NSNumber *commission_rate=[dic objectForKey:@"commission_rate"];
                NSNumber *p1=[dic objectForKey:@"promotion_price"];
                
                if (!p1) {
                    p1=[dic objectForKey:@"price"];
                }
                
                //返利多少钱RMB
                CGFloat moneyF = round((commission_rate.floatValue/10000)/p1.floatValue*[Appuntil convertFanli:000]);
                   NSLog(@"dic3=%@=%f",dic,moneyF);
                
                   [self refreshFanliLable:[NSString stringWithFormat:@"%.2f=", moneyF]];*/
                
            }
            break;
        }
    }
    
    if (removeDic) {
        [[taobaoTrackObject sharedInstance] removeObject:removeDic];
    }
    
    return NO;
}

- (void)asyncCallDelegate:(NSDictionary *)dic
{
    NSNumber *num_id = [dic objectForKey:@"num_iid"];
    if (_delegate && [_delegate respondsToSelector:@selector(webViewFanliInfo:productDic:)]) {
        [_delegate webViewFanliInfo:[self getShopNameByTid:[NSString stringWithFormat:@"%lld", num_id.longLongValue]] productDic:dic];
    }
}

- (BOOL)didTidExistIntaobaoTrackObject:(NSNumber *)tid
{
    NSMutableDictionary *removeDic = nil;
    
    for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
        NSNumber *num_id = [dic objectForKey:@"num_iid"];
        if (tid.longLongValue == num_id.longLongValue) {
            
            NSString *oldDate = [dic objectForKey:@"date"];
            if([AppUtil isTimeExpire:oldDate timeE:[AppUtil GetCurTime]])
            {
                //过期，更新数据
                removeDic = dic;
            }else
            {
                [self performSelector:@selector(asyncCallDelegate:) withObject:dic afterDelay:0];
                
                return YES;
                
            }
            break;
        }
    }
    
    if (removeDic) {
        [[taobaoTrackObject sharedInstance] removeObject:removeDic];
    }
    
    return NO;
}

//main thread excute this because of UIKit
-(void)loadCompleteNotify
{
    if ((_loadFailProductWebViewIds.count + _loadedProductWebViewIds.count) == _needfollowedProductUrls.count) {
        if ([_delegate respondsToSelector:@selector(WebViewLoadOk:failedNume:)]) {
            [_delegate WebViewLoadOk:nofanliNum failedNume:_loadFailProductWebViewIds.count];
        }
    }
     NSLog(@"wujiangwei end get shop cart nofanliNum %d _loadFailProductWebViewIds.count %d", nofanliNum, _loadFailProductWebViewIds.count);
}

-(void)startLoadOneWebViewForFanliInBg:(NSString *)taobaoProductId
{
    CookieWebView *aWebView=[[CookieWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    aWebView.tag=SINGLE_DEAL_TAOBAO_WEBVIEW_TAG;
    aWebView.taobaoProductId=taobaoProductId;
    aWebView.taobaoProductDic = _singleTaobaoProductDic;
    aWebView.delegate=self;
    
    NSString *shopSclick = [_singleTaobaoProductDic objectForKey:@"shop_click_url"];
    
    NSURL *url=[[[NSURL alloc] initWithString:shopSclick] autorelease];
    NSURLRequest *request=[[[NSURLRequest alloc] initWithURL:url] autorelease];
    [aWebView loadRequest:request];
}

-(void)timerStartLoadOneWebView:(NSNumber *)indexNumber
{
    NSInteger index=indexNumber.intValue;
    NSLog(@"wujiangwei load webview index %d", index);
    
    if (index+1 > _needfollowedProductUrls.count) {
        return;
    }
    
    NSLog(@"pid %@ ", [_needfollowedProductUrls objectAtIndex:index]);
    NSLog(@"shared Array %@", [taobaoTrackObject sharedInstance]);
    
    NSDictionary *taobaokeDic = [self getTaobaokeInfoByTid:[_needfollowedProductUrls objectAtIndex:index]];

    if (!taobaokeDic) {
        NSLog(@"error in shop cart");
    }
    
    //must main thread
    CookieWebView *aWebView=[[CookieWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    aWebView.taobaoProductId = [_needfollowedProductUrls objectAtIndex:index];
    aWebView.taobaoProductDic = taobaokeDic;
    aWebView.delegate=self;
    
    NSString *shopSclick = [taobaokeDic objectForKey:@"shop_click_url"];
    if (!shopSclick) {
        shopSclick = [taobaokeDic objectForKey:@"click_url"];
    }
    
    if (!shopSclick) {
        [_loadFailProductWebViewIds addObject:[_needfollowedProductUrls objectAtIndex:index]];
        return;
    }
    
    NSURL *url=[[[NSURL alloc] initWithString:shopSclick] autorelease];
    NSURLRequest *request=[[[NSURLRequest alloc] initWithURL:url] autorelease];
    [aWebView loadRequest:request];
    
    if (index+1 == _needfollowedProductUrls.count) {
        return;
    }
    //[self performSelectorOnMainThread:@selector(timerStartLoadOneWebView:) withObject:[NSNumber numberWithInt:++index] waitUntilDone:NO];
    [self performSelector:@selector(timerStartLoadOneWebView:) withObject:[NSNumber numberWithInt:++index] afterDelay:LOAD_WEBVIEW_INTERVAL];
}

//request follow url,and load it to webview because of web cookie?? here need comfirm!!!!
-(void)startFollowProduct
{
    for (TaoBaoShopDataObject *taobaoObject in _taobaoProductObjects) {
        
        //一个店铺仅仅一个宝贝去跟单
        //此处有重复跟单，暂时不做处理，保证购物车跟单最大程度成功
        for (NSString *productId in taobaoObject.shopProductIds) {
            NSNumberFormatter *numFM = [[[NSNumberFormatter alloc] init] autorelease];
            NSNumber *num_iid = [numFM numberFromString:productId];
            if ([taobaoTrackObject isThisTidNeedFollow:num_iid]) {
                //[self getTaobaoCid:productId];
                [_needfollowedProductUrls addObject:productId];
                break;
            }else
            {
                NSLog(@"this tid %@ is followed before,so not follow again", productId);
            }
        }
    }
    
    SAFE_INSTANCE_CHECK(_needfollowedProductUrls)
    
    //here just load the webview of fanli url for cookie
    if (!_needfollowedProductUrls.count) {
        [self loadCompleteNotify];
        return;
    }
    
    [self timerStartLoadOneWebView:[NSNumber numberWithInt:0]];
    
    //first time excute imm
    //[self performSelectorOnMainThread:@selector(timerStartLoadOneWebView:) withObject:[NSNumber numberWithInt:0] waitUntilDone:NO];
}

/*this interface is not exact,it's just a indicative value because of multithreading
 the number of succeed follow url at your request time, , -1 means invalided number*/
-(NSInteger)numberOfSucceedFollowProducts
{
    return _loadedProductWebViewIds.count;
}

-(NSInteger)numberOfLoadFailedUrls
{
    return _loadFailProductWebViewIds.count;
}

-(void)releaseWebViewById:(CookieWebView *)aWebView
{
    for (int i=0; i < _needfollowedProductUrls.count; i++) {
        if (aWebView == webViewArray[i]) {
            SAFE_RELEASE(webViewArray[i]);
            return;
        }
    }
    
    [aWebView release], aWebView=nil;
}

-(void)releaseSWebView:(CookieWebView *)aWebView
{
    if (aWebView.tag == SINGLE_DEAL_TAOBAO_WEBVIEW_TAG) {
        [aWebView release], aWebView=nil;
        return;
    }
}

#pragma mark - webview delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CookieWebView *cWebView=(CookieWebView *)webView;
    
    //单独处理webView跟单
    if (cWebView.tag == SINGLE_DEAL_TAOBAO_WEBVIEW_TAG) {
        NSNumberFormatter *numFM = [[[NSNumberFormatter alloc] init] autorelease];
        NSNumber *numId = [numFM numberFromString:cWebView.taobaoProductId];
        [taobaoTrackObject setProduct:numId RecordType:e_User_Detail_Followed_Product];
        
        NSLog(@"cWebView %@", cWebView);
        //[self releaseSWebView:cWebView];
        if (_delegate && [_delegate respondsToSelector:@selector(SwebViewLoadOk:)]) {
            [_delegate SwebViewLoadOk:YES];
        }
        
        return;
    }
    
    //批处理webView跟单
    NSLog(@"_loadedProductWebViewIds %@", _loadedProductWebViewIds);
    if(![taobaoFollowShopCartUntil didStringObjectExist:cWebView.taobaoProductId InArray:_loadedProductWebViewIds])
    {
        {
            if (cWebView.taobaoProductId) {
                [_loadedProductWebViewIds addObject:cWebView.taobaoProductId];
            }
            
            NSNumberFormatter *numFM = [[[NSNumberFormatter alloc] init] autorelease];
            NSNumber *numId = [numFM numberFromString:cWebView.taobaoProductId];
            [taobaoTrackObject setProduct:numId RecordType:e_User_Shopcart_Followed_Product];
            
            //[self performSelectorOnMainThread:@selector(releaseWebViewById:) withObject:cWebView waitUntilDone:NO];
        }
        [self performSelectorOnMainThread:@selector(loadCompleteNotify) withObject:nil waitUntilDone:NO];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    CookieWebView *cWebView=(CookieWebView *)webView;
    
    if (cWebView.tag == SINGLE_DEAL_TAOBAO_WEBVIEW_TAG) {
        NSLog(@"one linked web id %@ load failed", cWebView.taobaoProductId);
        {
            NSLog(@"cWebView %@", cWebView);
            //[self releaseSWebView:cWebView];
            if (_delegate && [_delegate respondsToSelector:@selector(SwebViewLoadOk:)]) {
                [_delegate SwebViewLoadOk:YES];
            }
        }
        return;
    }
    
    if(![taobaoFollowShopCartUntil didStringObjectExist:cWebView.taobaoProductId InArray:_loadedProductWebViewIds])
    {
        //here still deal with successful case for number, but do not treat it as one successful link cache
        {
            NSLog(@"one linked web id %@ load failed", cWebView.taobaoProductId);
            if (cWebView.taobaoProductId) {
                [_loadFailProductWebViewIds addObject:cWebView.taobaoProductId];
            }
            
            //[self performSelectorOnMainThread:@selector(releaseWebViewById:) withObject:cWebView waitUntilDone:NO];
        }
        [self performSelectorOnMainThread:@selector(loadCompleteNotify) withObject:nil waitUntilDone:NO];
    }
}

@end
