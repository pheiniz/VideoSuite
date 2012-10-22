//
//  LayerOverview.h
//  Videoplayer
//
//  Created by Paul Heiniz on 9/9/12.
//
//

#import <UIKit/UIKit.h>
#import "UIView+Animation.h"

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@protocol LayerViewDelegate

- (void)faceRecognitionLayerOn:(BOOL) value;
- (void)soundRecognitionLayerOn:(BOOL) value;
- (void)triviaLayerOn:(BOOL) value;

@end

@interface LayerOverview : UIView
- (IBAction)showOverview:(UIButton *)sender;
- (IBAction)switchFaceRecognition:(UIButton *)sender;
- (IBAction)switchSongRecognition:(UIButton *)sender;
- (IBAction)switchTrivia:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *showOverviewButton;
@property (weak, nonatomic) IBOutlet UIButton *switchFaceRecognitionButton;
@property (weak, nonatomic) IBOutlet UIButton *switchSongRecognitionButton;
@property (weak, nonatomic) IBOutlet UIButton *switchTriviaButton;
@property (nonatomic) BOOL overviewOpenFlag;
@property (nonatomic) BOOL showFaceRecognitionFlag;
@property (nonatomic) BOOL showSongRecognitionFlag;
@property (nonatomic) BOOL showTriviaFlag;
@property (assign) id<LayerViewDelegate> delegate;

@end
