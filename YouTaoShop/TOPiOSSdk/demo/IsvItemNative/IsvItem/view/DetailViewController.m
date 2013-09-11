//
//  DetailViewController.m
//  IsvItem
//
//  Created by tianqiao on 12-11-23.
//  Copyright (c) 2012年 tianqiao. All rights reserved.
//

#import "DetailViewController.h"
#import "TopToolBar.h"
#import "LoginUserInfo.h"
#import "JDY_Constants.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
TopToolBar *t;
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
    [self fillData:self.item];
    NSString * appkey = [[LoginUserInfo sharedInstance]appkey];
    NSString* userId = [LoginUserInfo sharedInstance].userId;
    t =[TopToolBar bindBaseView:self.navigationController.view  withApp:appkey tmallStyle:YES unreadCountFromUser:userId];
    t.top = t.top + 20;
    [t retain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillData:(ItemDO *)item
{
    if(item!=nil){
        self.m_gmtCreate.text = @"2012-12-22 00:00:00";
        self.m_status.text = @"上架中";
        self.m_num.text = item.num.description;
        self.m_price.text = item.price.description;
        self.m_title.text = item.itemTitle.description;
        
        if ([item itemImageUrl])
        {
            NSString * urlString  = [[NSString alloc]initWithFormat:@"%@_120x120.jpg",[item itemImageUrl]];
            NSURL * url = [[NSURL alloc]initWithString:urlString];
            NSData* imageData = [NSData dataWithContentsOfURL:url];
            self.m_imageView.image = [[UIImage alloc]initWithData:imageData];
        }
    }

}

@end
