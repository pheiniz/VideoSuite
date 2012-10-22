//
//  UIView+Animation.h
//  Videoplayer
//
//  Created by heiniz on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void)fadeIn:(float)secs alpha:(float)alpha option:(UIViewAnimationOptions)option;
- (void)fadeIn:(float)secs alpha:(float)alpha option:(UIViewAnimationOptions)option withCompletionBlock:(void (^)(BOOL finished))block;
- (void)fadeOut:(float)secs option:(UIViewAnimationOptions)option removeFromSuperview:(BOOL)remove;


@end
