//
//  MainViewControllerModel.m
//  testFuncDemo
//
//  Created by 吴江伟 on 13-9-25.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "MainViewControllerModel.h"

@implementation MainViewControllerModel

+ (NSArray *)getHomeUrlClickUrl
{
    return [NSArray arrayWithObjects:
            @"http://r.m.taobao.com/m3?p=mm_43457538_4062176_13208970&c=1005",//聚划算
            @"http://m.meilishuo.com/",//美丽说
            @"http://r.m.taobao.com/m3?p=mm_43457538_4062176_13214959&c=1563",//淘逛街
            @"http://m.zhe800.com",//折800wap版   触屏版 WebView Frame不对(宽度)   wap版本正常
            @"http://m.mogujie.com/",//蘑菇街   WebView Frame不对(高度)
            
            @"http://ai.m.taobao.com",//淘宝New（爱淘宝）
            @"http://m.tmall.com/",//天猫
            @"http://h5.m.taobao.com/cart/index.htm#cart",//购物车购物模式（淘宝购物车Url）
            @"http://r.m.taobao.com/m3?p=mm_43457538_4062176_13210967&c=1043",//天天特价
            @"http://page.m.tmall.com/ppj/ppj_PHONE.html",//品牌接
            @"http://r.m.taobao.com/m3?p=mm_43457538_4062176_13210966&c=1006",//淘宝女装
            
            @"http://m.taobao.com/",//淘宝
            @"http://wvs.m.taobao.com?pid=mm_43457538_0_0&backHiddenFlag=1",//手机充值
            @"http://yyz.m.tmall.com/cu/pptm.html?",//天猫特卖
            @"http://h5.m.taobao.com/mz/index.htm",//拇指斗价
            @"http://page.m.tmall.com/yushou/yushou_PHONE.html",//天猫预售
            
            @"http://m.taobao.com/channel/act/sale/quanbuleimu.html?",//淘宝类目
            @"http://m.tmall.com/tmallCate.htm?",//天猫类目
            @"http://yyz.m.tmall.com/cu/JRZDPwuxian.html?",//天猫大牌
            @"",//优质店铺  本地页面，无URL
             nil];
}

@end
