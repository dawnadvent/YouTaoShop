//
//  taobaoFollowShopCartUntil.h
//  Fanli
//
//  Created by jiangwei.wu on 13-4-11.
//  Copyright (c) 2013年 mxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CookieWebViewLoadDelegate <NSObject>

@optional

#pragma mark - 批处理delegate

//返回每个商品的返利信息
-(void)webViewFanliInfo:(NSString *)shopName productDic:(NSDictionary *)productDic;

-(void)WebViewGetTaobaokeInfoFailed;

-(void)WebViewLoadOk:(int)noFanliCount failedNume:(NSInteger)failed;

#pragma mark - 单独的处理
-(void)SwebViewLoadOk:(BOOL)isSucceed;

@end

#pragma mark - CookieWebView .h
//this webview just for load succeed,and then write cookie
@interface CookieWebView : UIWebView<NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSString *taobaoProductId;
@property (nonatomic, retain) NSDictionary *taobaoProductDic;

@end

#pragma mark -taobao shop data TaoBaoShopDataObject .h
//the object for shop product
@interface TaoBaoShopDataObject : NSObject

@property (nonatomic, retain)NSString *shopName;
@property (nonatomic, retain)NSMutableArray *shopProductIds;

//add one pid to shop product list,this interface has one function that do not add reduplicate id
-(void)addProductIdToShop:(NSString *)pid;

@end

@interface taobaoFollowShopCartUntil : NSObject<UIWebViewDelegate>

+(BOOL)didStringObjectExist:(NSString *)checkTaobaoProductId InArray:(NSArray *)array;

//代理
@property (nonatomic, assign) id<CookieWebViewLoadDelegate> delegate;

+(NSString *)getTaobaoUrlByProductId:(NSString *)productId;

//淘宝客API 接口

#pragma mark -  单任务模式

//单品跟单宝贝数据
@property (nonatomic, copy) NSDictionary *singleTaobaoProductDic;

-(void)startLoadOneWebViewForFanliInBg:(NSString *)taobaoProductId;

#pragma mark -  多任务模式

//js脚本解析出来的淘宝店铺对象
@property (nonatomic, retain) NSMutableArray *taobaoProductObjects;

//需要跟单的淘宝宝贝ID
@property (nonatomic, retain) NSMutableArray *needfollowedProductUrls;

//the pids ofload succeeful webview
@property (nonatomic, retain) NSMutableArray *loadFailProductWebViewIds;

//the pids ofload succeeful webview
@property (nonatomic, retain) NSMutableArray *loadedProductWebViewIds;

-(id)initWithNewJSString:(NSString *)jsString withShopNameString:(NSString *)shopNameString withTc:(NSString *)tc isAutoExcute:(BOOL)isAuto  delegate:(id)delegate;

//if isAuto is YES,well do the follow-up jop itself, this time,if tc is nil, user default tc value
-(id)initWithJSString:(NSString *)jsString withTc:(NSString *)tc isAutoExcute:(BOOL)isAuto delegate:(id)delegate;

//   prase products of string to products of array
-(NSArray *)parseProductsStringToArray:(NSString *)productsString;

//generate follow urls by products of taobao ids
-(void)generateNeedFollowedProductIdArrays;

//create threads to request follow url,and load it to webview because of web cookie?? here need comfirm!!!!
-(void)startFollowProduct;


@end
