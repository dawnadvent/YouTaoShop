//
//  customFollowShopCart.h
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-26.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FollowTaobaoSClickDelegate <NSObject>

@optional

- (void)SClickResultComeBack:(uint)succeedCount  failedCount:(uint)failCount;

- (void)WebViewSClickLoadResult:(BOOL)boolResult;

@end

typedef enum {
    Product_No_Fanli,
    Product_Not_Found_SClick,
    Product_Has_Fanli
}eProductFanliType;

#define kWProductId         @"wjwProductID"
#define kWProductName       @"wjwProductName"
#define kWProductShopName   @"wjwProductShopName"
#define KWProductHasFanli   @"wjwProductType"
#define kWProductSClick     @"wjwProductSClick"

#define kFanliInfo      @"wjwFanliInfo"
#define kFanliOrderTime @"wjwFanliInfoTime"
#define kFanliTimeType  @"wjwFanliTimeType"

#define kFanliArrayKey  @"wjwFirstKey"
#define kFanliFileName  @"wjwlzjFanliFileName"

@interface customFollowShopCart : NSObject<UIWebViewDelegate>

@property (nonatomic, assign) id<FollowTaobaoSClickDelegate> delegate;

@property (nonatomic, retain)NSMutableArray *array;
@property (nonatomic, retain)NSMutableArray *firstWebarray;

@property (nonatomic, copy)NSString *taobaoTime;

+ (NSString *)getOrderFanliInfo;
+ (void)resetFanliInfo;

+ (void)deleteItemInFanliInfoDisk:(NSArray *)deletePids;

+ (NSArray *)getFanliInfoToRefreshUI;

- (void)cancleDelayTask;

- (void)parseNewProductsStringToArray:(NSString *)productsString pids:(NSString *)pids;
- (void)parseProductsStringToArray:(NSString *)productsString;

- (void)addRecordOrderTimeListen:(UIWebView *)webView;

- (void)recordTime:(BOOL)type;

@end
