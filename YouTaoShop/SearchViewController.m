//
//  SearchViewController.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-11.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "SearchViewController.h"
#import "taobaoShopCartViewViewController.h"

#define kUser_Search_History    @"userSearchHistory0"


@interface SearchViewController ()
{
    NSArray *categoryArray;
    NSArray *smallCateArray;
    NSArray *imageArray;
    
    IBOutlet UITableView *categoryTableView;
    IBOutlet UITableView *smallCategoryTableview;
}

@property (nonatomic, retain)NSMutableArray *searchHistoryArray;
@property (nonatomic, retain)NSIndexPath *categorySelectIndex;

@end

@implementation SearchViewController

+ (BOOL)isStringAllNumber:(NSString *)inString
{
    NSString *string = [inString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(!string.length)
    {
        return YES;
    }

    return NO;
}

- (void)initSmallCategoryArray
{
    
    NSArray *array0 = [[[NSArray alloc] initWithObjects:@"防晒衫",@"T恤 女", @"T恤 男",@"雪纺衫", @"背心 女",@"背心 男", @"印花T恤",  @"字母T恤",@"卫衣 女", @"情侣装", @"衬衫 女", @"衬衫 男", @"长袖T恤 女", @"长袖T恤 男", @"小西装 女", @"开衫 女", @"外套 女", @"外套 男", @"牛仔衬衫 女", nil] autorelease];
    
    NSArray *array1 = [[[NSArray alloc] initWithObjects:@"连衣裙", @"印花连衣裙", @"长裙", @"半裙", @"短裙", @"雪纺连衣裙", @"碎花连衣裙", @"花苞短裙", @"蓬蓬裙", @"百褶裙", @"铅笔裙", @"吊带长裙", @"荷叶半边裙",nil] autorelease];
    
    NSArray *array2 = [[[NSArray alloc] initWithObjects: @"短裤 女",@"短裤 男", @"七分裤 女",@"七分裤 男", @"沙滩裤 女", @"沙滩裤 男",@"牛仔裤 女", @"牛仔裤 男", @"打底裤", @"休闲裤",  @"铅笔裤 女",@"九分裤 女", @"卷边牛仔裤 女", @"小脚裤",@"背带裤 女",nil] autorelease];
    
    NSArray *array3 = [[[NSArray alloc] initWithObjects:@"家居服", @"睡衣", @"内衣", @"内裤", @"蝴蝶结内衣", @"荧光色内衣", @"蕾丝内衣", @"印花内衣",nil] autorelease];
    
    NSArray *array4 = [[[NSArray alloc] initWithObjects:@"韩系", @"名媛", @"欧美", @"甜美", @"BF风", @"英伦", @"复古", @"性感", @"漏肩", @"闺蜜",nil] autorelease];
    
    NSArray *array5 = [[[NSArray alloc] initWithObjects:@"雪纺", @"显瘦", @"果冻包", @"糖果色", @"印花", @"荷叶边", @"镂空", @"原单", @"蕾丝", @"条纹", @"娃娃领", nil] autorelease];
    
    NSArray *array6 = [[[NSArray alloc] initWithObjects:@"帆布鞋 女", @"平底凉鞋 女", @"凉鞋 女", @"凉鞋 男",  @"洞洞鞋", @"坡跟凉鞋", @"豆豆鞋", @"柳钉", @"牛津鞋", @"学生 鞋",nil] autorelease];
    
    NSArray *array7 = [[[NSArray alloc] initWithObjects:@"单肩包", @"斜挎包", @"钱包", @"拉杆箱", @"透明包", @"迷你包", @"链条包", @"双肩包", @"学院 包",nil] autorelease];
    
    smallCateArray = [[NSArray alloc] initWithObjects:_searchHistoryArray, array0, array1, array2, array3, array4, array5, array6, array7,nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _searchHistoryArray = [[NSMutableArray alloc] initWithCapacity:5];
        
        //创建一个user defaults方法有多个，最简单得快速创建方法:
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        
        //从user defaults中获取数据:
        
        NSMutableArray *array = [accountDefaults objectForKey:kUser_Search_History];
        
        if (array && array.count) {
            _searchHistoryArray = [[NSMutableArray alloc] initWithArray:array];
        }
        
        categoryArray = [[NSArray alloc] initWithObjects:@"历史记录", @"上衣", @"裙子", @"裤子", @"内衣", @"热门风格", @"热门元素", @"包包", @"鞋子", nil];
        
        imageArray = [[NSArray alloc] initWithObjects:@"image0.png", @"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", @"image5.jpg", @"image6.jpg", @"image7.jpg", @"image8.jpg", nil];
        
        [self initSmallCategoryArray];
        
    }
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(_searchHistoryArray);
    SAFE_RELEASE(categoryArray);
    SAFE_RELEASE(smallCateArray);
    SAFE_RELEASE(imageArray);
    [categoryTableView release];
    [smallCategoryTableview release];
    [_searchTextView release];
    [_backButton release];
    [_menuButton release];
    [super dealloc];
}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == categoryTableView) {
        NSLog(@"categoryTableView numberOfRowsInSection %d", categoryArray.count);
        return categoryArray.count;
    }
    
    uint count = ((NSArray *)[smallCateArray objectAtIndex:_categorySelectIndex.row]).count;
    NSLog(@"numberOfRowsInSection %d", count);
    if (!count) {
        count = 1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *categoryTabCellId = @"categoryCell";
    static NSString *samllCategoryTabCellId = @"smallCategoryCell";
    
    if (tableView == categoryTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryTabCellId];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryTabCellId] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            //UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(158, 0, 1, 40)] autorelease];
            //view.tag = 1;
            //[view setBackgroundColor:[UIColor lightGrayColor]];
            //[cell addSubview:view];
            //[cell bringSubviewToFront:view];
        }
        
        if (indexPath.row == _categorySelectIndex.row) {
            [cell.textLabel setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        cell.textLabel.text = [categoryArray objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:samllCategoryTabCellId];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:samllCategoryTabCellId] autorelease];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    
    NSArray *array = [smallCateArray objectAtIndex:_categorySelectIndex.row];
    //NSLog(@"indexPath.row %d", indexPath.row);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    if (!array.count) {
        cell.textLabel.text = @"暂无搜索记录哦";
    }else
    {
        cell.textLabel.text = [array objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchTextView resignFirstResponder];
    if (table == categoryTableView) {

        UITableViewCell *preSelectCell = [table cellForRowAtIndexPath:_categorySelectIndex];
        //[preSelectCell.textLabel setBackgroundColor:[UIColor whiteColor]];

        UITableViewCell *SelectCell = [table cellForRowAtIndexPath:indexPath];
        //[SelectCell.textLabel setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
        
        self.categorySelectIndex = indexPath;
        
        if (indexPath.row) {
            smallCategoryTableview.tableFooterView = nil;
        }
        
        if (!indexPath.row) {
            if (!_searchHistoryArray.count) {
                smallCategoryTableview.tableFooterView = nil;
            }
        }
        [MobClick event:@"selectCategory"];
        [smallCategoryTableview reloadData];
        
        return;
    }
    
    if (table == smallCategoryTableview)
    {
        taobaoShopCartViewViewController *webContentViewControl = nil;
        webContentViewControl = [[[taobaoShopCartViewViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        
        NSArray *array = [smallCateArray objectAtIndex:_categorySelectIndex.row];
        if (!array.count) {
            return;
        }
        [MobClick event:@"seacrhMyKey"];
        NSString *searchString = [array objectAtIndex:indexPath.row];
        
        NSString *url = nil;
        NSURL *url2 = nil;
        if ([searchString hasPrefix:@"http://"]) {
            url = searchString;
            url2 = [NSURL URLWithString:url];
            webContentViewControl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webContentViewControl animated:YES];
            [MobClick event:@"searchUrl"];
            NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
            [webContentViewControl.webView loadRequest:request];
        }
        else if ([SearchViewController isStringAllNumber:searchString])
        {
            url = [taobaoFollowShopCartUntil getTaobaoUrlByProductId:searchString];
            url2 = [NSURL URLWithString:[url
                                         stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            webContentViewControl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webContentViewControl animated:YES];
            NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
            [MobClick event:@"searchId"];
            [webContentViewControl.webView loadRequest:request];
        }
        else{
            url = [NSString stringWithFormat:@"%@%@", @"http://r.m.taobao.com/s?p=mm_43457538_4062176_13210794&q=", searchString];
            url2 = [NSURL URLWithString:[url
                                         stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            webContentViewControl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webContentViewControl animated:YES];
            NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
            [MobClick event:@"searchKey"];
            [webContentViewControl.webView loadRequest:request];
        }
        
        if (![_searchHistoryArray containsObject:searchString]) {
            [_searchHistoryArray addObject:searchString];
            if (_categorySelectIndex.row == 0) {
                [smallCategoryTableview reloadData];
            }
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            [accountDefaults setObject:_searchHistoryArray forKey:kUser_Search_History];
        }
        
        if (![_searchHistoryArray containsObject:searchString]) {
            [_searchHistoryArray addObject:searchString];
            if (_categorySelectIndex.row == 0) {
                [smallCategoryTableview reloadData];
            }
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            [accountDefaults setObject:_searchHistoryArray forKey:kUser_Search_History];
        }
    }
}

- (void)clearSearchHistory
{
    [_searchHistoryArray removeAllObjects];
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:_searchHistoryArray forKey:kUser_Search_History];
    
    [smallCategoryTableview reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == smallCategoryTableview && _searchHistoryArray.count && indexPath.row == (_searchHistoryArray.count - 1) && !_categorySelectIndex.row) {
        
        if (!tableView.tableFooterView) {
            UIView *footSpinnerView=[[UIView alloc] initWithFrame:CGRectMake( 0, 0, 160, 40)];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10, 0, 140, 40);
            [button setTitle:@"清除历史记录" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clearSearchHistory) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [footSpinnerView insertSubview:button atIndex:1];
            
            tableView.tableFooterView = footSpinnerView;
            [footSpinnerView release];
        }
    }
}

#pragma mark - seach textField

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)seachEnd:(id)sender {
    [sender resignFirstResponder];
    
    UITextField *send = sender;
    
    taobaoShopCartViewViewController *webContentViewControl = nil;
    webContentViewControl = [[[taobaoShopCartViewViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    NSString *url = nil;
    NSURL *url2 = nil;
    if ([send.text hasPrefix:@"http://"]) {
        url = send.text;
        [MobClick event:@"searchUrl"];
        url2 = [NSURL URLWithString:url];
        NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
        webContentViewControl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webContentViewControl animated:YES];
        [webContentViewControl.webView loadRequest:request];
    }
    else if ([SearchViewController isStringAllNumber:send.text])
    {
        url = [taobaoFollowShopCartUntil getTaobaoUrlByProductId:send.text];
        url2 = [NSURL URLWithString:[url
                                     stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        webContentViewControl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webContentViewControl animated:YES];
        NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
        [MobClick event:@"searchId"];
        [webContentViewControl.webView loadRequest:request];
    }
    else{
        url = [NSString stringWithFormat:@"%@%@", @"http://r.m.taobao.com/s?p=mm_43457538_4062176_13210794&q=", send.text];
        url2 = [NSURL URLWithString:[url
                                     stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        webContentViewControl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webContentViewControl animated:YES];
        NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
        [MobClick event:@"searchKey"];
        [webContentViewControl.webView loadRequest:request];
    }
    
    if (![_searchHistoryArray containsObject:send.text]) {
        [_searchHistoryArray addObject:send.text];
        if (_categorySelectIndex.row == 0) {
            [smallCategoryTableview reloadData];
        }
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:_searchHistoryArray forKey:kUser_Search_History];
    }

}

#pragma mark - button click

- (IBAction)cancelSearch:(id)sender {
    
    [_searchTextView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:UIColorFromRGB(0xECF0F1)];
    self.navigationController.navigationBarHidden = YES;
    
    if (_isTextFirstRespond) {
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [[self view] addGestureRecognizer:recognizer];
        [recognizer release];
    }
}

- (void)setIsTextFirstRespond:(BOOL)isTextFirstRespond
{
    _isTextFirstRespond = isTextFirstRespond;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isTextFirstRespond) {
        [_searchTextView becomeFirstResponder];
        _searchTextView.frame = CGRectMake(40, 1, 220, 33);
        _backButton.hidden = NO;
        categoryTableView.frame = CGRectMake(categoryTableView.frame.origin.x, categoryTableView.frame.origin.y, categoryTableView.frame.size.width, categoryTableView.frame.size.height+45);
        smallCategoryTableview.frame = CGRectMake(smallCategoryTableview.frame.origin.x, smallCategoryTableview.frame.origin.y, smallCategoryTableview.frame.size.width, smallCategoryTableview.frame.size.height+45);
    }else{
        
    }
}

- (void)viewDidUnload {
    [categoryTableView release];
    categoryTableView = nil;
    [smallCategoryTableview release];
    smallCategoryTableview = nil;
    [self setSearchTextView:nil];
    [self setBackButton:nil];
    [self setMenuButton:nil];
    [super viewDidUnload];
}
@end
