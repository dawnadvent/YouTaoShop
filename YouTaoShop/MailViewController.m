//
//  MailViewController.m
//  Qingshopping
//
//  Created by 吴 江伟 on 13-6-13.
//  Copyright (c) 2013年 jiangwei.wu. All rights reserved.
//

#import "MailViewController.h"
#import "customFollowShopCart.h"
#import "MoreViewController.h"
#import "GetFanliViewController.h"

#import <sys/socket.h> // Per msqr
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#define kUSER_REBATE_PHONE   @"userRebatePhoneNum"
#define kUSER_REBATE_ZHIFUBAO_ACCOUNT    @"userRebateZhifubaoAccount"

@interface MailViewController ()
{
    IBOutlet UITextField *phoneNum;
    IBOutlet UITextField *zhifubaoAccount;
    IBOutlet UITextField *message;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UILabel *photoLable;
}

@property (retain, nonatomic)NSMutableArray *imageArray;

@end

@implementation MailViewController

- (IBAction)rebateNote:(id)sender {
    GetFanliViewController *fanliVC = [[[GetFanliViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    fanliVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fanliVC animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _imageArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (IBAction)editDone:(id)sender {
    [sender resignFirstResponder];
}


- (IBAction)selectPhoto:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [self presentModalViewController:imagePicker animated:YES];
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
   // Create a graphics image context
   UIGraphicsBeginImageContext(newSize);
   // Tell the old image to draw in this new context, with the desired
   // new size
   [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
   // Get the new image from the context
   UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
   // End the context
   UIGraphicsEndImageContext();
   // Return the new image.
   return newImage;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    [_imageArray addObject:image];
    photoLable.text = [NSString stringWithFormat:@"已经选择%d张图片", _imageArray.count];
   [self dismissModalViewControllerAnimated:YES];

   [picker release];
}

- (void)resignFirst
{
    [phoneNum resignFirstResponder];
    [zhifubaoAccount resignFirstResponder];
    [message resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:UIColorFromRGB(0xECF0F1)];
    UITapGestureRecognizer *tapGes = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirst)] autorelease];
    [scrollView addGestureRecognizer:tapGes];
    
    [scrollView setContentSize:CGSizeMake(320, 700)];
    //get user last time info
    
    //创建一个user defaults方法有多个，最简单得快速创建方法:
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    
    //从user defaults中获取数据:
    
    phoneNum.text = [accountDefaults objectForKey:kUSER_REBATE_PHONE];
    
    zhifubaoAccount.text = [accountDefaults objectForKey: kUSER_REBATE_ZHIFUBAO_ACCOUNT];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)FanliNote:(id)sender {
}

- (IBAction)senD:(id)sender {
    
    //创建一个user defaults方法有多个，最简单得快速创建方法:
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    if (zhifubaoAccount.text.length > 2) {
        [accountDefaults setObject:zhifubaoAccount.text forKey:kUSER_REBATE_ZHIFUBAO_ACCOUNT];
    }
    //添加数据到 user defaults:
    if (phoneNum.text.length > 8) {
        [accountDefaults setObject:phoneNum.text forKey:kUSER_REBATE_PHONE];
    }
    
    if (!message.text || !message.text.length) {
    //if (1) {
        if (!zhifubaoAccount.text) {
            [[RFToast sharedInstance] showToast:@"需要填写获取返利的支付宝账号哦" inView:self.view];
            [MobClick event:@"sendMailFailNoAccount"];
            return;
        }
        
        if (![customFollowShopCart getOrderFanliInfo] && !_imageArray.count) {
            [[RFToast sharedInstance] showToast:@"暂无购买记录，如果是聚划算频道参团购买宝贝，请把您的购买宝贝的订单号发送邮件给我们" inView:self.view];
            [MobClick event:@"sendMailFailNoFanliInfo"];
            return;
        }
    }
    
    [MobClick event:@"sendMail"];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

- (void)dealloc {
    [_imageArray release], _imageArray = nil;
    [phoneNum release];
    [zhifubaoAccount release];
    [message release];
    [scrollView release];
    [photoLable release];
    [super dealloc];
}

- (void)viewDidUnload {
    [phoneNum release];
    phoneNum = nil;
    [zhifubaoAccount release];
    zhifubaoAccount = nil;
    [message release];
    message = nil;
    [scrollView release];
    scrollView = nil;
    [photoLable release];
    photoLable = nil;
    [super viewDidUnload];
}

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (NSString *) macaddress
{
	int                    mib[6];
	size_t                len;
	char                *buf;
	unsigned char        *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl    *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	//NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
	
}

+ (NSString *) getCurrentVersion
{
    return (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"邮件:提现申请"];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject: @"bettersummer2013@163.com"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com", nil];
    [mailPicker setToRecipients: toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // 添加图片
    for (UIImage *image in _imageArray) {
        NSData *imageData = UIImagePNGRepresentation(image);            // png
        if (!imageData) {
            imageData = UIImageJPEGRepresentation(image, 1);    // jpeg
        }
        [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"photo.jpg"];
    }

    NSString *info = [NSString stringWithFormat:@"支付宝账号%@  手机号：%@ 订单信息 %@ App版本%@ sharedInfo-Weibo01622%d2239-Sina1001x001-0x%fQQ-x128x", zhifubaoAccount.text, phoneNum.text, [customFollowShopCart getOrderFanliInfo], [MailViewController getCurrentVersion], [[NSUserDefaults standardUserDefaults] integerForKey:userSharedSucceedKey], [MoreViewController getUserFanliTotal]];
    
    NSString *userMessage = message.text.length > 0 ? message.text : @"暂无留言";
    
    NSString *emailBody = [NSString stringWithFormat:@"为了让您正确的获取返利，请不要更改邮件内容 \n\n%@ \n\n您的订单号或留言：%@ \n\n%@", info, userMessage, [self macaddress]];
    [mailPicker setMessageBody:emailBody isHTML:NO];
    
    [self presentModalViewController: mailPicker animated:YES];
    //[[RFToast sharedInstance] showToast:@"为了让您正确的获取返利，请不要更改邮件内容" inView:mailPicker.view];
    [mailPicker release];
}

-(void)launchMailAppOnDevice
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请去系统应用:邮件中配置您的邮件账户信息，推荐gmail，技术支持QQ 461647731" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    return;
    
    //无研究，暂不支持
    NSString *recipients = @"bettersummer2013@163.com";
    NSString *emailBody = message.text ? message.text : @"暂无留言";
    NSString *body = emailBody;
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg = nil;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"返利申请邮件发送成功";
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:userSharedSucceedKey];
            [customFollowShopCart resetFanliInfo];
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
