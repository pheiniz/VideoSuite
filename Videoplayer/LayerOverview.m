//
//  LayerOverview.m
//  Videoplayer
//
//  Created by Paul Heiniz on 9/9/12.
//
//

#import "LayerOverview.h"

@implementation LayerOverview
@synthesize showOverviewButton;
@synthesize overviewOpenFlag;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        overviewOpenFlag = NO;
        CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
        showOverviewButton.transform = transform;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)showOverview:(UIButton *)sender {
    int viewWidth = self.frame.size.width;
    int viewHeight = self.frame.size.height;
    int superViewWidth = self.superview.frame.size.width;
    
    // init button states
    [[self switchFaceRecognitionButton] setSelected:![[NSUserDefaults standardUserDefaults] boolForKey:@"faceRecognitionOn"]];
    [[self switchSongRecognitionButton] setSelected:![[NSUserDefaults standardUserDefaults] boolForKey:@"soundRecognitionOn"]];
    [[self switchTriviaButton] setSelected:![[NSUserDefaults standardUserDefaults] boolForKey:@"triviaRecognitionOn"]];
    
    if (overviewOpenFlag) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.frame = CGRectMake(superViewWidth-viewWidth/2, 0, viewWidth, viewHeight);
                             
                             CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
                             showOverviewButton.transform = transform;
                         }
                         completion:^ (BOOL finished) {
                             overviewOpenFlag = NO;
                         }];
    }else{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = CGRectMake(superViewWidth-viewWidth, 0, viewWidth, viewHeight);
                         
                         CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
                         showOverviewButton.transform = transform;
                     }
                     completion:^ (BOOL finished) {
                         overviewOpenFlag = YES;
                     }];
    }
}

- (IBAction)switchFaceRecognition:(UIButton *)sender
{
    //negation of current value; is simply a switch
    BOOL faceRecognitionOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"faceRecognitionOn"];
    [sender setSelected:faceRecognitionOn];
    [delegate faceRecognitionLayerOn:!faceRecognitionOn];
}

- (IBAction)switchSongRecognition:(UIButton *)sender
{
    BOOL songRecognitionOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"soundRecognitionOn"];
    [sender setSelected:songRecognitionOn];
    [delegate soundRecognitionLayerOn:!songRecognitionOn];
}

- (IBAction)switchTrivia:(UIButton *)sender
{
    BOOL triviaRecognitionOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"triviaRecognitionOn"];
    [sender setSelected:triviaRecognitionOn];
    [delegate triviaLayerOn:!triviaRecognitionOn];
}
@end
