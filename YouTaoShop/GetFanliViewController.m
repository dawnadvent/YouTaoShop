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
{
    UIView *viewContentImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)imageTapEvent:(UITapGestureRecognizer *)tapGes
{
    UIImageView *imageView = (UIImageView *)tapGes.view;
    
    if (!imageView.tag) {
        imageView.tag = 1;
        viewContentImage = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, iphone5 ? 548 : 460)] autorelease];
        [viewContentImage addSubview:imageView];
    }else{
        [viewContentImage removeFromSuperview];
        imageView.tag = 0;
    }
}

- (void)addImageViewGes
{
    return;
    
    UITapGestureRecognizer *ges = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapEvent:)] autorelease];
    _MTaobaoOrderImageView.tag = 0;
    [_MTaobaoOrderImageView addGestureRecognizer:ges];
    
    ges = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapEvent:)] autorelease];
    _TaobaoOrderImageView.tag = 0;
    [_TaobaoOrderImageView addGestureRecognizer:ges];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:UIColorFromRGB(0xECF0F1)];
    _NoticeScrollView.frame = CGRectMake(0, 40, 320, iphone5 ? 548 : 460);
    _NoticeScrollView.contentSize = CGSizeMake(320, 600);
    
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
    [_MTaobaoOrderImageView release];
    [_TaobaoOrderImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNoticeScrollView:nil];
    [self setMTaobaoOrderImageView:nil];
    [self setTaobaoOrderImageView:nil];
    [super viewDidUnload];
}

#pragma mark - send Mail for fanli


- (IBAction)SendMail:(id)sender {
    MailViewController *mailVC = [[[MailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    mailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mailVC animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
