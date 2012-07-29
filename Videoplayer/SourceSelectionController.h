//
//  SourceSelectionController.h
//  Videoplayer
//
//  Created by heiniz on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "iCarousel.h"
#import "DataConnector.h"
#import "DataManager.h"
#import "StartScreenViewController.h"
#import "MoviePreview.h"
#import <MediaPlayer/MPMediaQuery.h>
#import <MediaPlayer/MPMediaItem.h>

@interface SourceSelectionController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (retain) NSMutableArray *movies;
@property (retain) Movie *selectedMovie;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;

@end
