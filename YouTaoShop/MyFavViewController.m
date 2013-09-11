//
//  MyFavViewController.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-17.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "MyFavViewController.h"
#import "SettingViewController.h"
#import "ProductInfoCell.h"
#import "taobaoTrackObject.h"
#import "UserInfoObject.h"
#import "SettingViewController.h"
#import "taobaoShopCartViewViewController.h"
#import "taobaoFollowShopCartUntil.h"
#import "TopIOSClient.h"
#import "taobaoData.h"

@interface MyFavViewController ()
{
    IBOutlet UIView *favline;
    IBOutlet UIView *historyLine;
    
    IBOutlet UILabel *myTitle;
    IBOutlet UIScrollView *contestScrollView;
    IBOutlet UITableView *favTableview;
    IBOutlet UITableView *historyTableView;
}

@property (nonatomic, copy)NSString *pidUrl;
@property (nonatomic, copy)NSString *pName;

//shopcart object
@property (nonatomic, retain)NSMutableArray *taobaoObjects;

@end

@implementation MyFavViewController

- (IBAction)myFavClick:(id)sender {
    contestScrollView.contentOffset = CGPointMake(0, 0);
    [self setFirstHight];
}

- (IBAction)historyClick:(id)sender {
    contestScrollView.contentOffset = CGPointMake(320, 0);
    [self setSecondHight];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization 
        _taobaoObjects = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)dealloc {
    SAFE_RELEASE(_pidUrl);
    SAFE_RELEASE(_pName);
    SAFE_RELEASE(_taobaoObjects);
    SAFE_RELEASE(_shopCartArray);
    
    [favTableview release];
    [historyTableView release];
    [contestScrollView release];
    [favline release];
    [historyLine release];
    [myTitle release];
    [_titleView release];
    [_menuButton release];
    [_backButton release];
    [super dealloc];
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
    NSLog(@"fav arrayString %@",arrayString);
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
                [_taobaoObjects addObject:taobaokeDic]; 
            }
        }
        else {
            [[RFToast sharedInstance] showToast:@"购物车宝贝均无返利，请返回直接下单购买" inView:self.view];
        }
    }else{
        [[RFToast sharedInstance] showToast:@"购物车宝贝均无返利，请返回直接下单购买" inView:self.view];
    }
    
    [favTableview reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    [self.view setBackgroundColor:UIColorFromRGB(0xECF0F1)];
    
    
    
    if (_isShopCart) {
        myTitle.text = @"购物车宝贝返利信息";
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:5];
        
        for (TaoBaoShopDataObject *tObject in _shopCartArray) {
            [mArray addObjectsFromArray:tObject.shopProductIds];
        }
        
        NSLog(@"mArray %@", mArray);
        [self sendTaobaokeWithArray:mArray];
        [mArray release];
        
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [[self view] addGestureRecognizer:recognizer];
        [recognizer release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (!buttonIndex) {
            taobaoShopCartViewViewController *vc = [[[taobaoShopCartViewViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://m.meilishuo.com/"]] autorelease];
            
            [vc.webView loadRequest:request];
            _isShopCart = YES;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![UserInfoObject getUserFavProduct].count && !_isShopCart && !_isHomeFav) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您还没收藏宝贝哦" message:@"进入淘宝宝贝详情页时，点击右下角星星进行收藏，去" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"下次", nil];
        alert.tag = 101;
        [alert show];
        [alert release];
    }
    
    [favTableview reloadData];
    _isHomeFav = NO;
    [super viewDidAppear:animated];
}

- (void)setTitleViewHidden
{
    _titleView.hidden = YES;
    self.view.frame = CGRectMake(0, 0, 320, iphone5 ? 500 :460-48);
    favTableview.frame = CGRectMake(0, 0, 320, iphone5 ? 500 :460-48);
}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isShopCart) {
        if (indexPath.row == [UserInfoObject getUserFavProduct].count - 1 && [UserInfoObject getUserFavProduct].count > 4) {
            return 100 + 44;
        }
    }
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_isShopCart) {
        NSLog(@"getUserFavProduct count %d", [UserInfoObject getUserFavProduct].count);
        return [UserInfoObject getUserFavProduct].count;
    }else{
        return _taobaoObjects.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *favTabCellId = @"favTabCellId";
    static NSString *historyTabCellId = @"historyTabCellId";
    
    if (!_isShopCart) {
        ProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:favTabCellId];
        if (!cell) {
            cell = [[[ProductInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:favTabCellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if ([UserInfoObject getUserFavProduct].count <= indexPath.row) {
            return cell;
        }
        ;
        [cell refreshCellWithDic:[[UserInfoObject getUserFavProduct] objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
    ProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:historyTabCellId];
    if (!cell) {
        cell = [[[ProductInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyTabCellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_taobaoObjects.count <= indexPath.row) {
        return nil;
    }
    
    [cell refreshCellWithDic:[_taobaoObjects objectAtIndex:indexPath.row]];
    
    return cell;
}


- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ProductInfoCell *SelectCell = (ProductInfoCell *)[table cellForRowAtIndexPath:indexPath];
    [MobClick event:@"favShopping"];
    self.pName = SelectCell.pName;
    self.pidUrl = [taobaoFollowShopCartUntil getTaobaoUrlByProductId:[NSString stringWithFormat:@"%lld", SelectCell.pid.longLongValue]];
    
    NSString *url = nil;
    NSURL *url2 = nil;
    taobaoShopCartViewViewController *webContentViewControl = nil;
    webContentViewControl = [[[taobaoShopCartViewViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    url = _pidUrl;
    url2 = [NSURL URLWithString:url];
    webContentViewControl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webContentViewControl animated:YES];
    
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
    
    [webContentViewControl.webView loadRequest:request];
}



- (void)viewDidUnload {
    [favTableview release];
    favTableview = nil;
    [historyTableView release];
    historyTableView = nil;
    [contestScrollView release];
    contestScrollView = nil;
    [favline release];
    favline = nil;
    [historyLine release];
    historyLine = nil;
    
    [myTitle release];
    myTitle = nil;
    [self setTitleView:nil];
    [self setMenuButton:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}

#pragma mark - hightlight table
- (void)setFirstHight
{
    [favline setBackgroundColor:[UIColor darkGrayColor]];
    [historyLine setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)setSecondHight
{
    [historyLine setBackgroundColor:[UIColor darkGrayColor]];
    [favline setBackgroundColor:[UIColor lightGrayColor]];
}

#pragma mark - scroll view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x >= 1) {
        [self setSecondHight];
    }else{
        [self setFirstHight];
    }
}

@end
