//
//  GetFanliViewController.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-13.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "GetFanliViewController.h"
#import "MailViewController.h"

@interface GetFanliViewController ()

@end

@implementation GetFanliViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:UIColorFromRGB(0xECF0F1)];
    _NoticeScrollView.frame = CGRectMake(0, 40, 320, iphone5 ? 548 : 460);
    _NoticeScrollView.contentSize = CGSizeMake(320, 650);
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
    
    [MobClick event:@"noteHowRebate"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_NoticeScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNoticeScrollView:nil];
    [super viewDidUnload];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
