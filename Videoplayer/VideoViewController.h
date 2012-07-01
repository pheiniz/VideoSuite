//
//  VideoViewController.h
//  Videoplayer
//
//  Created by heiniz on 05.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+Animation.h"
#import "DataConnector.h"

@interface VideoViewController : UIViewController

@property (retain) MPMoviePlayerController *moviePlayerController;
@property (retain) UIView *funnyFactsView;
@property (retain) UIView *currentMusicView;

@end
