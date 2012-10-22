//
//  ActorDetailsViewController.m
//  Videoplayer
//
//  Created by Paul Heiniz on 8/6/12.
//
//

#import "ActorDetailsView.h"

@interface ActorDetailsView ()

@end

@implementation ActorDetailsView
@synthesize buttonBackgroundView;
@synthesize biographyLabel;
@synthesize birthdayLabel;
@synthesize actorPicture;
@synthesize nameLabel;
@synthesize homepageLabel;
@synthesize backgroundView;
 
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)initWithActor:(Actor *)actor
{
    self.actorPicture.image = [UIImage imageWithData:[actor picture]];
    self.nameLabel.text = [actor name];
    self.biographyLabel.text = [actor biography];
    self.birthdayLabel.text = [NSString stringWithFormat:@"%@ \nin %@", [actor birthdate], [actor birthplace]];
    self.homepageLabel.text = [actor homepage];
}

-(void)awakeFromNib
{
    [[backgroundView layer] setCornerRadius:15];
    [[backgroundView layer] setBorderWidth:3];
    [[backgroundView layer] setBorderColor:[UIColor blackColor].CGColor];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [backgroundView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [backgroundView addGestureRecognizer:swipeLeft];
    
    UIImage *image = [UIImage imageNamed:@"gradient_s_w"];
    buttonBackgroundView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    buttonBackgroundView.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [buttonBackgroundView setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)backgroundSelected:(id)sender {
    [self fadeOut:0.5 option:UIViewAnimationOptionCurveEaseIn removeFromSuperview:YES];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer {

}

- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {

}

@end
