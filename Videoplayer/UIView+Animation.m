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

- (void)fadeOut:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^ (BOOL finished) {
                         if (finished) {
                             [self removeFromSuperview];
                         }
                     }];
}

@end
