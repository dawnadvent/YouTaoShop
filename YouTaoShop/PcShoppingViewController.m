//
//  PcShoppingViewController.m
//  fanli
//
//  Created by jiangwei.wu on 13-8-13.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "PcShoppingViewController.h"
#import "taobaoShopCartViewViewController.h"

@interface PcShoppingViewController ()
{
    
    IBOutlet UITextField *searchTextFeild;
}

@end

@implementation PcShoppingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)search:(id)sender {
    [MobClick event:@"searchIDPc"];
    
    taobaoShopCartViewViewController *webContentViewControl = nil;
    webContentViewControl = [[[taobaoShopCartViewViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    NSString *url = nil;
    NSURL *url2 = nil;

    url = [taobaoFollowShopCartUntil getTaobaoUrlByProductId:searchTextFeild.text];
    url2 = [NSURL URLWithString:[url
                                 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    webContentViewControl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webContentViewControl animated:YES];
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url2] autorelease];
    [webContentViewControl.webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[searchTextFeild becomeFirstResponder];
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [searchTextFeild release];
    [super dealloc];
}
- (void)viewDidUnload {
    [searchTextFeild release];
    searchTextFeild = nil;
    [super viewDidUnload];
}
@end
