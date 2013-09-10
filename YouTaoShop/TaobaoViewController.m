//
//  TaobaoViewController.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-24.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "TaobaoViewController.h"
#import "taobaoShopCartViewViewController.h"
#import "shopCell.h"

#define SHOPARRAY_PLIST_FILE   @"shopFile.plist"

#define kShopcartNote       @"shopCartNote"

@interface TaobaoViewController ()
{
    IBOutlet UIImageView *shopcartNoteView;
    
    IBOutlet UITableView *shopTableView;
}

@property (nonatomic, retain)NSArray *shopList;

@end

@implementation TaobaoViewController

#pragma mark - get confige file


- (IBAction)hiddenNote:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kShopcartNote];
    [shopcartNoteView removeFromSuperview];
}

- (NSString *)getContentWithName:(NSString *)fileName
{
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths1 objectAtIndex:0];
    [documentsDirectory stringByAppendingPathComponent:fileName];
    return [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:fileName];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.shopList = [NSArray arrayWithContentsOfFile:[self getContentWithName:SHOPARRAY_PLIST_FILE]];
        //NSLog(@"shoplist %@", _shopList);
    }
    return self;
}

- (IBAction)taobaoShortCutClick:(UIButton *)sender {
    taobaoShopCartViewViewController *webContentViewControl = nil;
    webContentViewControl = [[[taobaoShopCartViewViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    NSString *urlS = nil;
    NSURL *url2 = nil;
    
    switch (sender.tag) {
        //用户淘宝快捷入口  暂无佣金
        case 1000:
            //购物车
            urlS = @"http://d.m.taobao.com/my_bag.htm";
            [MobClick event:@"taobaoShopCart"];
            webContentViewControl.alertShopCartFanli = YES;
            break;
        
            
        default:
            urlS = @"http://m.taobao.com/?v=0";
            break;
    }
    
    url2 = [NSURL URLWithString:urlS];
    webContentViewControl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webContentViewControl animated:YES];
    
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
    
    [webContentViewControl.webView loadRequest:request];
}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    uint ret = _shopList.count%2 ? _shopList.count/2+1 : _shopList.count/2;
    NSLog(@"indexPath.row %d", indexPath.row);
    if (indexPath.row == ret -1) {
        return 235*0.8 + 77;
    }
    return 235*0.8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    uint ret = _shopList.count%2 ? _shopList.count/2+1 : _shopList.count/2;
    NSLog(@"cell count %d", ret);
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *shopTabCellId = @"shopCellId";

    shopCell *cell = [tableView dequeueReusableCellWithIdentifier:shopTabCellId];
    if (!cell) {
        cell = [[[shopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopTabCellId rootViewCtrol:self] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSDictionary *dic0 = nil;
    NSDictionary *dic1 = nil;
    NSLog(@"row %d", indexPath.row);
    if (indexPath.row*2 < _shopList.count) {
        dic0 = [_shopList objectAtIndex:indexPath.row*2];
    }
    if (indexPath.row*2 + 1< _shopList.count) {
        dic1 = [_shopList objectAtIndex:indexPath.row*2 + 1];
    }
    
    [cell refreshCell:[dic0 safeObjectForKey:@"localImage"] sclick:[dic0 safeObjectForKey:@"sClick"] image2:[dic1 safeObjectForKey:@"localImage"] sclick2:[dic1 safeObjectForKey:@"sClick"]];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:UIColorFromRGB(0xECF0F1)];
    self.navigationController.navigationBarHidden = YES;
    /*NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kShopcartNote];
    if (!num.boolValue) {
        shopcartNoteView.frame = CGRectMake(0, iphone5 ? 0 : -40, 320, 548);
        //[self.view addSubview:shopcartNoteView];
    }*/
}

- (void)viewDidAppear:(BOOL)animated
{
    //shopTableView.frame = CGRectMake(shopTableView.frame.origin.x, shopTableView.frame.origin.y, 320, iphone5 ? 508- shopTableView.frame.origin.y:420-shopTableView.frame.origin.y);
    [shopTableView reloadData];
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    SAFE_RELEASE(_shopList);
    [shopTableView release];
    [shopcartNoteView release];
    [_backButton release];
    [_menuButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [shopTableView release];
    shopTableView = nil;
    [shopcartNoteView release];
    shopcartNoteView = nil;
    [self setBackButton:nil];
    [self setMenuButton:nil];
    [super viewDidUnload];
}
@end
