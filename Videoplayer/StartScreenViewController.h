//
//  ViewController.h
//  Videoplayer
//
//  Created by heiniz on 05.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DataManager.h"
#import "HorizontalTableView.h"
#import "ActorView.h"
#import "ActorDetailsView.h"
#import "UIView+Animation.h"

@interface StartScreenViewController : UIViewController <HorizontalTableViewDelegate>

@property (nonatomic, strong) Movie *movie;

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet HorizontalTableView *actorsView;
@property (weak, nonatomic) IBOutlet UILabel *criticsLabel;
@property (weak, nonatomic) IBOutlet UILabel *audienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *imdbLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;

@property (retain, nonatomic) NSArray *castArray;

@end
