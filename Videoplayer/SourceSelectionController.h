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
#import "StartScreenViewController.h"

@interface SourceSelectionController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (retain) NSMutableDictionary *moviesDictionary;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;

@end
