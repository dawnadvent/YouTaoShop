//
//  UIImageView+SDWebCache.m
//  SDWebData
//
//  Created by stm on 11-7-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SDImageView+SDWebCache.h"
#import "SDWebDataManager.h"
#define kImageActViewTag 123434
@implementation UIImageView(SDWebCacheCategory)

- (void)setImageWithURLAndActivity:(NSURL *)url size:(CGSize)size
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
   
    activityView.frame = CGRectMake((size.width-20)/2,(size.height-20)/2, 20.0f, 20.0f);
    
    activityView.tag=kImageActViewTag;
    //[self insertSubview:activityView atIndex:3];
    [self addSubview:activityView];
    [activityView startAnimating];
    [activityView release];
   	[self setImageWithURL:url refreshCache:NO];
    
}

- (void)setImageWithURL:(NSURL *)url
{
	[self setImageWithURL:url refreshCache:NO];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache
{
    
	[self setImageWithURL:url refreshCache:refreshCache placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder
{
    SDWebDataManager *manager = [SDWebDataManager sharedManager];
	
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
	if (placeholder) {
         self.image = placeholder;
    }
   
	
    if (url)
    {
        [manager downloadWithURL:url delegate:self refreshCache:refreshCache];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebDataManager sharedManager] cancelForDelegate:self];
}

#pragma mark -
#pragma mark SDWebDataManagerDelegate

- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache
{
    self.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *img=[UIImage imageWithData:aData];
    
    if(img&&img.size.width>0){
        if ((self.image==nil && !isCache) ||self.tag) {
            self.alpha = 0;
            self.image=img;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4f];
            self.alpha =1.0;
            [UIView commitAnimations];
        }else{
            self.image=img;
        }
    
    }
    UIActivityIndicatorView *activityView=(UIActivityIndicatorView *)[self viewWithTag:kImageActViewTag];
    if (activityView&&[activityView respondsToSelector:@selector(stopAnimating)]) {
        [activityView stopAnimating];
        [activityView removeFromSuperview];
    }

    	
}
- (void)webDataManager:(SDWebDataManager *)dataManager didFailWithError:(NSError *)error{
    NSLog(@"webDataManager--didFailWithError");
    UIActivityIndicatorView *activityView=(UIActivityIndicatorView *)[self viewWithTag:kImageActViewTag];
    if (activityView&&[activityView respondsToSelector:@selector(stopAnimating)]) {
        [activityView stopAnimating];
        [activityView removeFromSuperview];
    }
}
@end
