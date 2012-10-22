//
//  ActorDetailsViewController.h
//  Videoplayer
//
//  Created by Paul Heiniz on 8/6/12.
//
//

#import <UIKit/UIKit.h>
#import "UIView+Animation.h"
#import <QuartzCore/QuartzCore.h>
#import "Actor.h"

@interface ActorDetailsView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *actorPicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *homepageLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
- (IBAction)backgroundSelected:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *buttonBackgroundView;
@property (weak, nonatomic) IBOutlet UITextView *biographyLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

-(void)initWithActor:(Actor *)actor;

@end
