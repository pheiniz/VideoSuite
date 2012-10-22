//
//  VideoViewController.h
//  Videoplayer
//
//  Created by heiniz on 05.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+Animation.h"
#import "DataManager.h"
#import "IMDBConnector.h"
#import "Movie.h"
#import "ActorDetailsView.h"
#import "LayerOverview.h"


@interface VideoViewController : UIViewController <LayerViewDelegate>

@property (nonatomic, strong) Movie *movie;

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (retain) UIView *funnyFactsView;
@property (retain) UIView *currentMusicView;
@property (retain) NSMutableArray *faceViews;
@property (nonatomic) NSNumber *currentPauseTime; //holds wether pause was pressed; needed when user pauses and then skips few seconds because pause-notification is fired again; need to convert it from time to time, but it looses accuracy. thus directly as nssnumber; negative = not paused
@property (nonatomic, strong) NSArray *triviaArray;
@property (nonatomic) int currentTrivia;
@property (nonatomic, strong) LayerOverview *layerOverview;
@property (nonatomic, strong) NSTimer *triviaTimer;

- (void)changeTrivia:(NSTimer *)timer;

@end
