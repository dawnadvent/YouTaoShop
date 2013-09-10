//
//  RFToast.m
//  ChargeDemo
//
//  Created by roger qian on 13-1-10.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "RFToast.h"
#import <QuartzCore/QuartzCore.h>

#define kToastFont [UIFont systemFontOfSize:14.0f]
#define kHorizontalPadding          10.0
#define kVerticalPadding            10.0
#define kCornerRadius               8.0
#define kMaxLines                   3
#define kMaxWidth                   160.0f
#define kMaxHeight                  100.0f
#define kFadeDuration               0.7
#define kOpacity                    0.7

@implementation RFToast

#pragma mark - 
#pragma mark - Singleton Stuff

static RFToast *_instance = nil;
+ (id)sharedInstance
{
    @synchronized(self)
    {
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (!_instance) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    
    return nil;   
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}


- (void)dealloc
{
    _label = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kOpacity];
        self.layer.cornerRadius = kCornerRadius;     
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:6.0];
        [self.layer setShadowOffset:CGSizeMake(4.0, 4.0)];
        
        UILabel *label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:kToastFont];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setNumberOfLines:kMaxLines];
        [label setTextColor:[UIColor whiteColor]];
        [self addSubview:label];
        _label = label;
        [label release];
        _stoped = YES;
    }
    return self;
}

- (void)startAnimate
{   
    [UIView beginAnimations:@"fade_in" context:(__bridge void*)self];
    [UIView setAnimationDuration:kFadeDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self setAlpha:kOpacity];
    [UIView commitAnimations];
}

- (void)showToast:(NSString *)message inView:(UIView *)superView
{
    if (_stoped) {
        CGSize text_size = [message sizeWithFont:kToastFont constrainedToSize:CGSizeMake(kMaxWidth, kMaxHeight) lineBreakMode:_label.lineBreakMode];
        [_label setText:message];    
        [_label setFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, text_size.width, text_size.height)];
        [self setFrame:CGRectMake(0.0f, 0.0f, text_size.width + kHorizontalPadding * 2, text_size.height + kVerticalPadding * 2)];
        //self.center = CGPointMake(superView.frame.size.width / 2, superView.frame.size.height - self.frame.size.height / 2 - kVerticalPadding);
        self.center = CGPointMake(superView.frame.size.width / 2, superView.frame.size.height/2 - self.frame.size.height / 2 - kVerticalPadding);
        [self setAlpha:0.0f];
        self.hidden = NO;
        _stoped = NO;
        [superView addSubview:self];
        [self startAnimate];
    }    
}

- (void)showToast:(NSString *)message
{
    UIWindow *superView = [[UIApplication sharedApplication] keyWindow];
    if (_stoped) {
        CGSize text_size = [message sizeWithFont:kToastFont constrainedToSize:CGSizeMake(kMaxWidth, kMaxHeight) lineBreakMode:_label.lineBreakMode];
        [_label setText:message];    
        [_label setFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, text_size.width, text_size.height)];
        [self setFrame:CGRectMake(0.0f, 0.0f, text_size.width + kHorizontalPadding * 2, text_size.height + kVerticalPadding * 2)];
        self.center = CGPointMake(superView.frame.size.width / 2, superView.frame.size.height - self.frame.size.height / 2 - kVerticalPadding - 55.0f);    
        [self setAlpha:0.0f];
        self.hidden = NO;
        _stoped = NO;
        [superView addSubview:self];
        [self startAnimate];
    }    
}

#pragma mark - Animation Delegate Method

- (void)animationDidStop:(NSString*)animationID finished:(BOOL)finished context:(void *)context
{    
    UIView *toast = (UIView *)(__bridge id)context;   
    
    if([animationID isEqualToString:@"fade_in"]) {
        
        [UIView beginAnimations:@"fade_out" context:(__bridge void*)toast];
        [UIView setAnimationDelay:2.0f];
        [UIView setAnimationDuration:kFadeDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [toast setAlpha:0.0];
        [UIView commitAnimations];
        
    } 
    else if ([animationID isEqualToString:@"fade_out"]) {        
        toast.hidden = YES;
        [toast removeFromSuperview];
        _stoped = YES;
    }    
}

@end
