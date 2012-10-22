//
//  UIView+Animation.m
//  Videoplayer
//
//  Created by heiniz on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)fadeIn:(float)secs alpha:(float)alpha option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.alpha = alpha;
                     }
                     completion:nil];
}

- (void)fadeIn:(float)secs alpha:(float)alpha option:(UIViewAnimationOptions)option withCompletionBlock:(void (^)(BOOL finished))block
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.alpha = alpha;
                     }
                     completion:block];
}

- (void)fadeOut:(float)secs option:(UIViewAnimationOptions)option removeFromSuperview:(BOOL)remove
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^ (BOOL finished) {
                         if (finished && remove) {
                             [self removeFromSuperview];
                         }
                     }];
}

@end
