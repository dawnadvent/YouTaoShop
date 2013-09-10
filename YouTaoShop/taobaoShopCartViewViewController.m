//
//  taobaoShopCartViewViewController.m
//  YouTaoShop
//
//  Created by jiangwei.wu on 13-5-29.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//


#import "taobaoShopCartViewViewController.h"
#import "FilterTaobaoTaobaoProduct.h"

#import "taobaoUtil.h"

#import "taobaoData.h"

#import "taobaoTrackObject.h"
#import "AppUtil.h"
#import "UserInfoObject.h"

#import "ASIHTTPRequest.h"

#import "MyFavViewController.h"

#define SEARCH_FOLLOW_ORDER_ALERT   100

BOOL isNeedFollowUrl = NO;
uint searchAlertFlag = 0;

@interface taobaoShopCartViewViewController ()
{
    IBOutlet UIView *alertFanliView;
    
    IBOutlet UIButton *getFanliButton;
    
    uint hasSClickCount;
    uint succeedWebLoadCount;
    uint failedWebLaodCount;
    
    UIProgressView *progressView;
}

@property (nonatomic, retain)NSNumber *taobaoNumId;
@property (nonatomic, retain)NSString *taobaoStringId;

@property (nonatomic, retain)NSString *taobaoShopCartProductIDString;
@property (nonatomic, retain)NSString *taobaoShopNamesString;
//custom follow taobao shopcart
@property (nonatomic, retain)customFollowShopCart *customFollowObject;

//unused
@property (nonatomic, retain)taobaoFollowShopCartUntil *followOneProduct;
@property (nonatomic, retain)taobaoFollowShopCartUntil *followShopCart;

@property (nonatomic, retain)NSString *finishedUrlString;

@property (nonatomic, retain)NJKWebViewProgress *progressProxy;

@end

@implementation taobaoShopCartViewViewController
{
    UIScrollView *infoScrollView;
    
    NSMutableArray *shopLableArray;
    
    BOOL isNeedMarkButton;
    
    BOOL recordFlag;
}

@synthesize taobaoShopCartProductIDString = _taobaoShopCartProductIDString;
@synthesize followOneProduct = _followOneProduct;
@synthesize followShopCart = _followShopCart;
@synthesize finishedUrlString = _finishedUrlString;

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isNeedMarkButton = YES;
    }
    return self;
}

#pragma mark - dealloc

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(noteUserWaitingOrder) object:nil];
    
    [[SHKActivityIndicator currentIndicator] hidden];
    
    
    [self releaseCustomFollowTaobaoProductObject];
    [self releaseTaobaoParseDataUntil];

    [self releaseTaobaoOnePID];
    
    SAFE_RELEASE(_taobaoShopNamesString);
    SAFE_RELEASE(shopLableArray);
    SAFE_RELEASE(_progressProxy);
    [_returnButton release];
    [_webView release];
    [_fanliNumberLable release];
    [_backImage release];
    [_forwardImage release];
    [_refreshImage release];
    [_ToolBaseView release];
    [_favImageView release];
    [getFanliButton release];
    [alertFanliView release];
    [super dealloc];
}

#pragma mark - brower operation
- (IBAction)backBrower:(id)sender {
    [_webView goBack];
}

- (IBAction)forwardBrower:(id)sender {
    [_webView goForward];
}

- (IBAction)refreshBrower:(id)sender {
    UIImageView *reImageV = (UIImageView *)((UITapGestureRecognizer *)sender).view;
    if (!reImageV.tag) {
        [_webView reload];
        reImageV.image = [UIImage imageNamed:@"button-close.png"];
        reImageV.tag = 1;
    }else{
        reImageV.image = [UIImage imageNamed:@"btn-bottom-option-refresh.png"];
        [_webView stopLoading];
        reImageV.tag = 0;
    }

}

- (IBAction)favGes:(id)sender {
    
    if (!_taobaoNumId) {
        [[RFToast sharedInstance] showToast:@"暂时只支持收藏宝贝" inView:self.view];
        [MobClick event:@"favFailledEx"];
        return;
    }
    
    if ([UserInfoObject getFavDicByPid:_taobaoNumId]) {
        [UserInfoObject deleteFavByPid:_taobaoNumId];
        [[RFToast sharedInstance] showToast:@"取消收藏宝贝成功" inView:self.view];
        [MobClick event:@"cancleFav"];
        _favImageView.tag = 0;
    }else{
        NSMutableDictionary *dic = [taobaoTrackObject getTaobaokeInfoByPid:_taobaoNumId];
        if (!dic) {
            [[RFToast sharedInstance] showToast:@"暂时只支持收藏有返利的宝贝" inView:self.view];
            [MobClick event:@"favFailled"];
        }else{
            [UserInfoObject addFavToFav:[taobaoTrackObject getTaobaokeInfoByPid:_taobaoNumId]];
            [[RFToast sharedInstance] showToast:@"宝贝收藏成功" inView:self.view];
        }
        [MobClick event:@"favClick"];
        _favImageView.tag = 1;
    }
    
    [self refreshWebControl];
}


#pragma mark - taobao until
- (void)SwebViewLoadOk:(BOOL)isSucceed
{
    NSString *originalText = _fanliNumberLable.text;
    NSString *nowText = nil;
    
    if (isSucceed) {
        nowText = [NSString stringWithFormat:@"%@", originalText];
    }else
    {
        nowText = [NSString stringWithFormat:@"宝贝暂无返利哦"];
    }
    
    _fanliNumberLable.text = nowText;
}

- (BOOL)didTidExist:(NSNumber *)tid
{
    NSMutableDictionary *removeDic = nil;
    NSLog(@"[taobaoTrackObject sharedInstance] %@", [taobaoTrackObject sharedInstance]);
    
    for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
        NSNumber *num_id = [dic objectForKey:@"num_iid"];
        if (num_id.longLongValue == tid.longLongValue) {
            
            NSString *oldDate = [dic objectForKey:@"date"];
            if([AppUtil isTimeExpire:oldDate timeE:[AppUtil GetCurTime]])
            {
                //过期，更新数据
                removeDic = dic;
            }else
            {
                NSNumber *commission_rate=[dic objectForKey:@"commission_rate"];
                NSNumber *p1=[dic objectForKey:@"promotion_price"];
                
                if (!p1) {
                    p1=[dic objectForKey:@"price"];
                }
                
                //返利多少钱RMB
                CGFloat moneyF = [AppUtil convertFanliNum:(commission_rate.floatValue/10000)*p1.floatValue];
                NSLog(@"dic3=%@=%f",dic,moneyF);
                if (moneyF > 100) {
                    [self refreshFanliLable:[NSString stringWithFormat:@"返%.1f元", moneyF]];
                }else
                    [self refreshFanliLable:[NSString stringWithFormat:@"返%.2f元", moneyF]];
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

#pragma mark - follow taobao url
-(void)followTaobaoId:(NSString *)taobaoId  dic:(NSDictionary *)taobaoDic
{
    taobaoFollowShopCartUntil *followShopCartObject = [[taobaoFollowShopCartUntil alloc] init];
    if (_followOneProduct) {
        _followOneProduct.delegate = nil;
    }
    self.followOneProduct = followShopCartObject;
    followShopCartObject.delegate = self;
    followShopCartObject.singleTaobaoProductDic = taobaoDic;
    
    [followShopCartObject startLoadOneWebViewForFanliInBg:taobaoId];
}

-(void)releaseTaobaoOnePID
{
    _followOneProduct.delegate = nil;
    SAFE_RELEASE(_followOneProduct);
}

#pragma mark - 高级方案 :javascript get sclick and follow taobao product

- (void)SClickResultComeBack:(uint)succeedCount failedCount:(uint)failCount
{
    [[SHKActivityIndicator currentIndicator] hidden];
    NSString *string = nil;
    if (!failCount) {
        string = [NSString stringWithFormat:@"%d宝贝有返利,正在跟单中", succeedCount];
    }else if(succeedCount){
        string = [NSString stringWithFormat:@"共%d宝贝有返利,%d宝贝无返利", succeedCount, failCount];
    }else{
        string = @"您购物车内宝贝都没有返利哦";
        hasSClickCount = 0;
        [[SHKActivityIndicator currentIndicator] displayActivity:string];
        [[SHKActivityIndicator currentIndicator] hideAfterDelay:2.0];
        return;
    }
    hasSClickCount = succeedCount;
    [[SHKActivityIndicator currentIndicator] displayActivity:string];
}

- (void)noteUserWaitingOrder
{
    [[SHKActivityIndicator currentIndicator] hidden];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"返利信息确认中，请等待3秒后提交订单"];
    [[SHKActivityIndicator currentIndicator] hideAfterDelay:3.5];
}

- (void)WebViewSClickLoadResult:(BOOL)boolResult
{
    if (boolResult) {
        succeedWebLoadCount++;
    }else{
        failedWebLaodCount++;
    }
    [[SHKActivityIndicator currentIndicator] hidden];
    NSString *string = [NSString stringWithFormat:@"共%d宝贝 有%d宝贝跟单成功", hasSClickCount, succeedWebLoadCount];
    [[SHKActivityIndicator currentIndicator] displayActivity:string];
    [[SHKActivityIndicator currentIndicator] hideAfterDelay:2.5];

    [self performSelector:@selector(noteUserWaitingOrder) withObject:nil afterDelay:2.5];
}

//解析淘宝购物车内数据，并且做跟单处理
-(void)allocCustomFollowTaobaoProductObject
{
    //用JS解析当前订单中的淘宝宝贝IDs
    [[SHKActivityIndicator currentIndicator] hidden];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"对购物车内宝贝跟单中..."];
    if (!_taobaoShopCartProductIDString) {
        self.taobaoShopCartProductIDString = [self injectJavascript];
    }
    _customFollowObject = [[customFollowShopCart alloc] init];
    _customFollowObject.delegate = self;
    [_customFollowObject parseProductsStringToArray:_taobaoShopCartProductIDString];
    
    [_customFollowObject addRecordOrderTimeListen:_webView];
}

//解析淘宝购物车内数据，并且做跟单处理
-(void)allocNewCustomFollowTaobaoProductObject
{
    //用JS解析当前订单中的淘宝宝贝IDs
    [[SHKActivityIndicator currentIndicator] hidden];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"对购物车内宝贝跟单中..."];

    _customFollowObject = [[customFollowShopCart alloc] init];
    _customFollowObject.delegate = self;
    [_customFollowObject parseNewProductsStringToArray:_taobaoShopNamesString pids:_taobaoShopCartProductIDString];
    
    [_customFollowObject addRecordOrderTimeListen:_webView];
}

-(void)releaseCustomFollowTaobaoProductObject
{
    _customFollowObject.delegate = nil;
    [_customFollowObject cancleDelayTask];
    SAFE_RELEASE(_customFollowObject);
    SAFE_RELEASE(_taobaoShopCartProductIDString);
}

#pragma mark - taobao 购物车

uint lableHeight = 25;

- (NSString *)injectNewJavascript {
    NSString *js = @"function getPidList()\
    {\
        var itemlist = document.getElementsByClassName('itemlist');\
        var ret;\
        for(var i = 0; i < itemlist.length; i++)\
        {\
            var nodeitems = itemlist[i].childNodes;\
            for(var j = 0; j < nodeitems.length; j++)\
            {\
                var shopName = document.getElementsByClassName('shop')[i].childNodes[1].getElementsByTagName('h3')[0].innerHTML;\
                if(nodeitems [j]. firstChild. childNodes[0].checked)\
                {\
                    var pName = nodeitems[j].getElementsByTagName('h4')[0].innerHTML;\
                    if(!i&&!j)\
                    {\
                        ret=pName;\
                    }\
                    else\
                    {\
                        ret = ret +'-*-'+ pName;\
                    }\
                }\
            }\
        }\
        return ret;\
    }";
    
    [_webView stringByEvaluatingJavaScriptFromString:js];
    
    NSString *jsRetString = [_webView stringByEvaluatingJavaScriptFromString:@"getPidList();"];
    NSLog(@"new jsRetString %@", jsRetString);
    return jsRetString;
}

- (NSString *)injectNewJavascriptGetPids {
    NSString *js = @"function getPidList()\
    {\
    var itemlist = document.getElementsByClassName('itemlist');\
    var ret;\
    for(var i = 0; i < itemlist.length; i++)\
    {\
    var nodeitems = itemlist[i].childNodes;\
    var shopName = document.getElementsByClassName('shop')[i].childNodes[1].getElementsByTagName('h3')[0].innerHTML;\
    for(var j = 0; j < nodeitems.length; j++)\
    {\
    if(nodeitems [j]. firstChild. childNodes[0].checked)\
    {\
    var pId = nodeitems[j].getElementsByTagName('a')[0].getAttribute('data-itemid');\
    if(!i&&!j)\
    {\
    ret=pId;\
    }\
    else\
    {\
    ret = ret +'-*-'+ pId;\
    }\
    }\
    }\
    }\
    return ret;\
    }";
    
    [_webView stringByEvaluatingJavaScriptFromString:js];
    
    NSString *jsRetString = [_webView stringByEvaluatingJavaScriptFromString:@"getPidList();"];
    NSLog(@"new jsRetString %@", jsRetString);
    return jsRetString;
}

-(void)allocNewTaobaoUntilToParseData
{
    //用JS解析当前订单中的淘宝宝贝IDs
    self.taobaoShopCartProductIDString = [self injectNewJavascriptGetPids];
    self.taobaoShopNamesString = [self injectNewJavascript];
    //购物车入口，tc值固定为v0
    taobaoFollowShopCartUntil *followShopCartObject = [[taobaoFollowShopCartUntil alloc] initWithNewJSString:_taobaoShopCartProductIDString withShopNameString:_taobaoShopNamesString withTc:@"v0" isAutoExcute:YES delegate:nil];
    self.followShopCart = followShopCartObject;
    NSLog(@"new _followShopCart.taobaoProductObjects %@", _followShopCart.taobaoProductObjects);
    //self.followShopCart.delegate=self;
    [followShopCartObject release];
}

//解析淘宝购物车内数据，并且做跟单处理
-(void)allocTaobaoUntilToParseData
{
    //用JS解析当前订单中的淘宝宝贝IDs
    self.taobaoShopCartProductIDString = [self injectJavascript];
    
    //购物车入口，tc值固定为v0
    taobaoFollowShopCartUntil *followShopCartObject = [[taobaoFollowShopCartUntil alloc] initWithJSString:_taobaoShopCartProductIDString withTc:@"v0" isAutoExcute:NO delegate:self];
    self.followShopCart = followShopCartObject;
    //self.followShopCart.delegate=self;
    [followShopCartObject release];
    
    return;
}


-(void)releaseTaobaoParseDataUntil
{
    infoScrollView.hidden = YES;
    [infoScrollView removeFromSuperview];
    infoScrollView = nil;
    SAFE_RELEASE(shopLableArray);
    SAFE_RELEASE(_followShopCart);
    SAFE_RELEASE(_taobaoShopCartProductIDString);
}

- (void)startSearchFollowOrder
{
    MyFavViewController *favVC = [[[MyFavViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    favVC.isShopCart = YES;
    favVC.shopCartArray = _followShopCart.taobaoProductObjects;
    favVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:favVC animated:YES];
    favVC.backButton.hidden = NO;
    favVC.menuButton.hidden = YES;
}

- (IBAction)getFanliClick:(id)sender {
    if (searchAlertFlag) {
        //
    }
    
    [self startSearchFollowOrder];
}


#pragma mark - taobao api

-(void)getTaobaoCid:(NSString *)tid{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:@"taobao.item.get" forKey:@"method"];
    [params setObject:@"num_iid,cid" forKey:@"fields"];
    NSLog(@"tid==%@",tid);
    [params setObject:tid forKey:@"num_iid"];
    
    TopIOSClient *iosClient =[TopIOSClient getIOSClientByAppKey:kTaobaoKey];
    
    [iosClient api:@"POST" params:params target:self cb:@selector(taobaoCidResponse:) userId:@""needMainThreadCallBack:true];
    [params release];
}

-(void)taobaoCidResponse:(id)data
{
    
    if ([data isKindOfClass:[TopApiResponse class]])
    {
        TopApiResponse *response = (TopApiResponse *)data;
        NSLog(@"[response content]==%@",[response content]);
        if ([response content]){
            
            NSDictionary *dic=(NSDictionary *)[[response content] JSONValue] ;
            NSLog(@"taobaoCidResponse dic %@", dic);
            NSDictionary *dic1=[dic objectForKey:@"item_get_response"] ;
            NSDictionary *dic2=[dic1 objectForKey:@"item"];
            NSNumber *taobaoNId = [dic2 objectForKey:@"num_iid"];
            NSString *cid  =[NSString stringWithFormat:@"%@",[dic2 objectForKey:@"cid"]];
            NSLog(@"taobaoId %@ cid %@", [taobaoNId class], [cid class]);
            
            if (taobaoNId.longLongValue != _taobaoNumId.longLongValue) {
                NSLog(@"taobaoNId is not equil,so ignore");
                return;
            }
            
            if ([[FilterTaobaoTaobaoProduct getFilterCid] containsObject: cid]) {
                //虚拟商品暂无返利
                [self refreshFanliLable:@"虚拟无返利"];
            }
            //聚划算商品返利特殊
            else if(0){
                //聚划算商品返利特殊
            }
            else{
                [self sendTaobaoke:_taobaoStringId];
            }
        }
        else {
            [self sendTaobaoke:_taobaoStringId];
        }
    }
}

-(void)sendTaobaoke:(NSString *)tid
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:@"taobao.taobaoke.widget.items.convert" forKey:@"method"];
    [params setObject:@"shop_click_url,\
                            nick,seller_credit_score,\
                        num_iid,\
                            title,pic_url,price,promotion_price,commission,commission_rate,click_url" forKey:@"fields"];
    //seller_id,shop_click_url,nick,seller_credit_score,num_iid,title,pic_url,price,promotion_price,commission,commission_rate,click_url
    NSLog(@"taobaoSId==%@",tid);
    [params setObject:tid forKey:@"num_iids"];
    [params setObject:@"true" forKey:@"is_mobile"];
    TopIOSClient *iosClient =[TopIOSClient getIOSClientByAppKey:kTaobaoKey];
    
    [iosClient api:@"POST" params:params target:self cb:@selector(fanliResponse:) userId:@""needMainThreadCallBack:true];
    [params release];
}

-(void)fanliResponse:(id)data
{
    if ([data isKindOfClass:[TopApiResponse class]])
    {
        TopApiResponse *response = (TopApiResponse *)data;
        if ([response content])
        {
            NSDictionary *dic=(NSDictionary *)[[response content] JSONValue] ;
            NSLog(@"fanliResponse dic %@", dic);
            NSDictionary *dic1=[dic objectForKey:@"taobaoke_widget_items_convert_response"] ;
            NSDictionary *dic2=[dic1 objectForKey:@"taobaoke_items"];
            NSArray *array =[dic2 objectForKey:@"taobaoke_item"];
            
            NSLog(@"dic=%@",dic);
            
            if (array&&array.count > 0) {
                NSDictionary *dic3=[array objectAtIndex:0];
                NSNumber *taobaoNId = nil ;
                taobaoNId = [dic3 objectForKey:@"num_iid"];
                NSNumber *commission_rate=[dic3 objectForKey:@"commission_rate"];
                NSNumber *p1=[dic3 objectForKey:@"promotion_price"];
                
                if (!p1) {
                    p1=[dic3 objectForKey:@"price"];
                }
                
                //返利多少钱RMB
                CGFloat moneyF = [AppUtil convertFanliNum:(commission_rate.floatValue/10000)*p1.floatValue];
                NSLog(@"dic3=%@=%f",dic3,moneyF);
                
                if (!moneyF) {
                    [self getJuhuasuanFanli:_taobaoStringId];
                }else{
                    if (moneyF > 100) {
                        [self refreshFanliLable:[NSString stringWithFormat:@"返%.1f元", moneyF]];
                    }else
                        [self refreshFanliLable:[NSString stringWithFormat:@"返%.2f元", moneyF]];
                }
                
                //跟单 此处存在crash bug，等待淘宝客API权限有了之后，将会开放该处代码
                if (0) {
                    if ([taobaoTrackObject isThisTidNeedFollow:taobaoNId]) {
                        [self followTaobaoId:[NSString stringWithFormat:@"%llu", taobaoNId.longLongValue] dic:dic3];
                    }else
                    {
                        NSLog(@"this tid %@ is followed before,so not follow again", taobaoNId);
                    }
                }
                
                [taobaoTrackObject AddTaobaokeInfoToSInstance:dic3];
                
            }else{
                //@"无返利";
                [self refreshFanliLable:@"无返利"];
            }
        }
        else {
            //@"error";
            NSLog(@"%@",[(NSError *)[response error] userInfo]);
            [self refreshFanliLable:@"NetError"];
        }
        
    }
}

#pragma mark - view control

- (void)refreshFanliLable:(NSString *)labText
{
    _fanliNumberLable.alpha = 0;
    [UIView animateWithDuration:0.6 animations:^{
        _fanliNumberLable.alpha = 1.0;
        _fanliNumberLable.text = labText;
    } completion:/*^(BOOL finished) {
        if (finished) {
            _fanliNumberLable.alpha = 0;
            [UIView animateWithDuration:0.6 animations:^{
                _fanliNumberLable.alpha = 1.0;
                _fanliNumberLable.text = labText;
            }];
        }
    }*/nil];
    
}

- (void)getTaobaokeInfo:(NSString *)urlS
{
    NSString *taobaoLId = [taobaoUtil getTaobaoIdWithDic:urlS];
    
    if ([taobaoLId isEqualToString:_taobaoStringId]) {
        return;
    }
    NSNumberFormatter *Nfor = [[[NSNumberFormatter alloc] init] autorelease];
    
    self.taobaoStringId = taobaoLId;
    self.taobaoNumId = [Nfor numberFromString:_taobaoStringId];
    
    NSLog(@"getTaobaokeInfo tid %@", _taobaoNumId);
    
    if (_taobaoStringId) {
        if (![self didTidExist:_taobaoNumId]) {
            //没有淘宝客信息，去获取
            [self getTaobaoCid:[taobaoUtil getTaobaoIdWithDic:urlS]];
        }else{
            //有淘宝客信息  didTidExist 已经刷新了text
        }
    }else{
        _fanliNumberLable.alpha = 1.0;
    }

}

- (void)refreshWebControl
{
    if (_webView.canGoBack) {
        _backImage.image = [UIImage imageNamed:@"btn-bottom-option-pre-on.png"];
    }else
    {
        _backImage.image = [UIImage imageNamed:@"btn-bottom-option-pre.png"];
    }
    
    if (_webView.canGoForward) {
        _forwardImage.image = [UIImage imageNamed:@"btn-bottom-option-next-on.png"];
    }else{
        _forwardImage.image = [UIImage imageNamed:@"btn-bottom-option-next.png"];
    }
    

    if ([UserInfoObject getFavDicByPid:_taobaoNumId]) {
        _favImageView.image = [UIImage imageNamed:@"button-fav-on@2x.png"];
        _favImageView.tag = 1;
    }else{
        _favImageView.image = [UIImage imageNamed:@"button-fav@2x.png"];
        _favImageView.tag = 0;
    }
}

- (void)alertImageTap:(UITapGestureRecognizer *)tapGes
{
    [tapGes.view removeFromSuperview];
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - progressView.progress options:0 animations:^{
            progressView.alpha = 0.0;
        } completion:nil];
    }
    
    [progressView setProgress:progress animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //((UIScrollView *)[_webView.subviews objectAtIndex:0]).delegate = self;
    
    [[RFToast sharedInstance] showToast:@"左滑(手势)让浏览器后退哦" inView:self.view];
    
    _ToolBaseView.frame = CGRectMake(0, iphone5 ? 548 - 33 : 548 - 33, 320, 33);
    [self refreshWebControl];
    
    //TODO:
    progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
    //0x6874FA
    [progressView setProgressTintColor:UIColorFromRGB(0xb72973)];
    progressView.frame = CGRectMake(0, 0, 320, 2);
    [self.view addSubview:progressView];
    
    self.progressProxy = [[[NJKWebViewProgress alloc] init] autorelease];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;

    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gesReturn)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
}

- (NSString *)injectJavascript {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *jsPath=[FilterTaobaoTaobaoProduct dataFilePath:@"js"];
    if (![manager fileExistsAtPath:jsPath]) {
        jsPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"js"];
    }
    NSString *js = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:NULL];
    
    [_webView stringByEvaluatingJavaScriptFromString:js];
    return [_webView stringByEvaluatingJavaScriptFromString:@"detectProducts();"];
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
    
    NSDictionary *dic=(NSDictionary *)[responseString JSONValue];
    NSLog(@"responseString==%@",dic);
    NSDictionary *dataDic=[dic safeObjectForKey:@"data"];
    if ([dataDic objectForKey:@"ju_commission_rate"]&&[dataDic objectForKey:@"ju_price"]) {
        NSString *rate=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"ju_commission_rate"]];
        float num=[rate floatValue];
        NSNumber *pid = [dataDic safeObjectForKey:@"pid"];
        NSLog(@"ju_commission_rate=%f",num);
        NSNumber *promotion_price = nil;
        for (NSMutableDictionary *dic in [taobaoTrackObject sharedInstance]) {
            NSLog(@"CommissionRate dic %@", dic);
            NSNumber *dTid = [dic objectForKey:@"num_iid"];
            if (dTid.longLongValue == pid.longLongValue) {
                //刷新返利比值
                //和淘宝commission_rate规则一致
                NSNumber *numI = [NSNumber numberWithFloat:rate.floatValue * 10000];
                [dic setObject:numI forKey:@"commission_rate"];
                promotion_price = [dic safeObjectForKey:@"promotion_price"];
                break;
            }
        }
        CGFloat fanli = [AppUtil convertFanliNum:[promotion_price floatValue]*num];
        if (fanli > 100.0) {
            [self refreshFanliLable:[NSString stringWithFormat:@"返%.1f元", fanli]];
        }else
            [self refreshFanliLable:[NSString stringWithFormat:@"返%.2f元", fanli]];
             
    }else{
        [self refreshFanliLable:@"无返利"];
    }
}

#pragma mark -
#pragma mark webview delegate

- (void)newStartFollowShopCart
{
    [self allocNewTaobaoUntilToParseData];
    [self allocNewCustomFollowTaobaoProductObject];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
   
    
    NSString *url=[[request URL] absoluteString];
    NSLog(@"navigationType %i", navigationType);
    
    //for taobao page redirect to taobao App
    if (![url hasPrefix:@"http://"]&&![url hasPrefix:@"https://"]) {
        return NO;
    }
    
    NSLog(@"shouldStartLoadWithRequest requestUrl=%@",url);
    
    //别的地方进入淘宝标准版本，需要重定向到淘宝触屏版本
    NSRange rangStand = [url rangeOfString:@"v=1"];
    NSRange taobao = [url rangeOfString:@"m.taobao.com"];
    NSRange tmall = [url rangeOfString:@"m.tmall.com"];
    if (rangStand.location != NSNotFound && (taobao.location != NSNotFound || tmall.location != NSNotFound) && ![url hasPrefix:@"http://wvs.m.taobao.com/buy_item.htm?v=1&ttid"]) {
        url = [url stringByReplacingOccurrencesOfString:@"v=1" withString:@"v=0"];
        NSLog(@"new url %@", url);
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        return NO;
    }
    
    //进入淘宝确认订单结算页面
    NSString *key = @"order!cartIds=";
    NSString *taobaoPreUrl = @"http://h5.m.taobao.com/cart/index.htm";
    NSRange rang = [url rangeOfString:key];
    NSLog(@"requestUrl %@ range location %d length %d", url, rang.location, rang.length);
    if ([url hasPrefix:taobaoPreUrl] && rang.length) {
        [self performSelector:@selector(newStartFollowShopCart) withObject:nil afterDelay:0.4];
    }
    
    //can not be release
    if ([url hasPrefix:taobaoPreUrl] && rang.length) {
        getFanliButton.hidden = NO;
    }else if(![url hasPrefix:@"https://wapcashier.alipay.com/cashier/exCashier.htm"]){
        getFanliButton.hidden = YES;
    }else{
        getFanliButton.hidden = YES;
    }

    NSRange payRang = [url rangeOfString:@"wujiangwei_order_comfirm_call"];
    if (payRang.location != NSNotFound) {
        NSLog(@"user comfirm order now _customFollowObject %@", _customFollowObject);
        recordFlag = YES;
        [_customFollowObject recordTime:YES];
        [[RFToast sharedInstance] showToast:@"返利商品购买信息记录成功,首页可以看到总返利金额哦" inView:self.view];
        return NO;
    }
    
	return YES;
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    succeedWebLoadCount = 0;
    failedWebLaodCount = 0;
    [[SHKActivityIndicator currentIndicator] hidden];
    NSString *requestUrl=[[[webView request ] URL] absoluteString];
    NSLog(@"webViewDidStartLoad requestUrl=%@\nresponse %@",requestUrl, [webView request]);
    [[SHKActivityIndicator currentIndicator] displayActivity:@"努力加载中" inView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //[[RFToast sharedInstance] showToast:@"网速不给力哦" inView:self.view];
}

- (IBAction)closeAlertView:(id)sender {
    [alertFanliView removeFromSuperview];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *requestUrl=[[[webView request ] URL] absoluteString];
    NSLog(@"webViewDidFinishLoad requestUrl=%@",requestUrl);
    [self getTaobaokeInfo:requestUrl];

    [[SHKActivityIndicator currentIndicator] hide];
    
    [self refreshWebControl];
    
    NSRange aliRange = [requestUrl rangeOfString:@"alipay"];
    
    //无淘宝客权限时，使用javascript实现的跟单机制  淘宝8月分改版前的代码，最新版本taobao跟单代码见New
    if ([requestUrl hasPrefix:@"http://d.m.taobao.com/confirm.htm"]) {
        getFanliButton.hidden = NO;
        //跟单
        [self allocCustomFollowTaobaoProductObject];
        [MobClick event:@"shopcartSettlement"];
        //用户查看购物车详情显示
        [self allocTaobaoUntilToParseData];
    }else if(aliRange.location == NSNotFound){
        //跟单release
        [self releaseCustomFollowTaobaoProductObject];
        
        //用户查看购物车详情显示 release
        [self releaseTaobaoParseDataUntil];
        getFanliButton.hidden = YES;
    }else{
        getFanliButton.hidden = YES;
    }
    
    //taobaokeAPI 跟单
    //支付页面
    
    if (aliRange.location != NSNotFound) {
        [[RFToast sharedInstance] showToast:@"宝贝跟单已成功！确认收货24小时内即可申请返利到账" inView:self.view];
        if (!recordFlag) {
            NSLog(@"wujiangwei replenish record type _customFollowObject %@", _customFollowObject);
            recordFlag = YES;
            [_customFollowObject recordTime:NO];
        }
    }

    _refreshImage.image = [UIImage imageNamed:@"btn-bottom-option-refresh.png"];
    _refreshImage.tag = 0;
    
}

#pragma mark - xib 

- (IBAction)returnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gesReturn{
    if (_webView.canGoBack) {
        [_webView goBack];
    }else
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - shop cart delegate

-(int)getShopNameIndex:(NSString *)shopname
{
    int i = 0;
    
    for (NSMutableArray *AObject in shopLableArray) {
        UILabel *pNameL = [AObject objectAtIndex:0];
        if (!(pNameL.text.length)) {
            return i;
        }
        i++;
    }
    
    return i;
}

-(void)webViewFanliInfo:(NSString *)shopName productDic:(NSDictionary *)productDic
{
    return;
    NSString *tShopName = [productDic objectForKey:@"title"];
    
    NSNumber *commission_rate=[productDic objectForKey:@"commission_rate"];
    NSNumber *p1=[productDic objectForKey:@"promotion_price"];
    
    if (!p1) {
        p1=[productDic objectForKey:@"price"];
    }
    
    //返利多少钱RMB
    CGFloat moneyF = [AppUtil convertFanliNum:(commission_rate.floatValue/10000)*p1.floatValue];
    
    NSLog(@"dic3=%@=%f",productDic,moneyF);
    
    NSString *tFanliCountS = [NSString stringWithFormat:@"返%.2f元", moneyF];
    
    uint index = [self getShopNameIndex:shopName];
    
    NSMutableArray *tSArray = [shopLableArray objectAtIndex:index];

    NSLog(@"tSArray %@", tSArray);
    for (UILabel *lable in tSArray) {
        if (lable.tag == 1) {
            lable.text = tShopName;
        }else{
            lable.text = tFanliCountS;
        }
    }
}

-(void)WebViewGetTaobaokeInfoFailed
{
    return;
    uint index = [self getShopNameIndex:nil];
    
    NSMutableArray *tSArray = [shopLableArray objectAtIndex:index];
    
    NSLog(@"tSArray %@", tSArray);
    for (UILabel *lable in tSArray) {
        if (lable.tag == 1) {
            lable.text =  @"您有一件宝贝无返利哦";
            [lable setBackgroundColor:[UIColor redColor]];
        }else{
            lable.text =  @"您可以查看下";
            //[lable setBackgroundColor:[UIColor redColor]];
        }
    }
}

-(void)WebViewLoadOk:(int)noFanliCount failedNume:(NSInteger)failed
{
    //[[SHKActivityIndicator currentIndicator] hidden];
    //[[SHKActivityIndicator currentIndicator] displayActivity:@"全部处理完成" inView:self.view];
}

- (void)viewDidUnload {
    [self setFavImageView:nil];
    [getFanliButton release];
    getFanliButton = nil;
    [alertFanliView release];
    alertFanliView = nil;
    [super viewDidUnload];
}
@end
