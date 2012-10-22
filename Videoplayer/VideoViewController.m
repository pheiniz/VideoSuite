//
//  VideoViewController.m
//  Videoplayer
//
//  Created by heiniz on 05.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController(MovieControllerInternal)
-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType;
-(void)applyUserSettingsToMoviePlayer;
-(void)moviePlayBackDidFinish:(NSNotification*)notification;
-(void)loadStateDidChange:(NSNotification *)notification;
-(void)moviePlayBackStateDidChange:(NSNotification*)notification;
-(void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification;
-(void)installMovieNotificationObservers;
-(void)removeMovieNotificationHandlers;
-(void)deletePlayerAndNotificationObservers;

-(void)findFaces;
-(void)fadeOutFaceViews;
-(void)faceSelected:(id) sender;

-(void)fadeInTriviaInfoViews;
-(void)fadeOutTriviaInfoViews;

-(void)fadeInMusicInfoViewWithTitle: (NSString *) title;
-(void)fadeOutMusicInfoViews;
@end

@implementation VideoViewController

@synthesize moviePlayerController = _moviePlayerController;
@synthesize funnyFactsView;
@synthesize currentMusicView;
@synthesize faceViews;
@synthesize movie;
@synthesize currentPauseTime;
@synthesize layerOverview;
@synthesize triviaArray;
@synthesize currentTrivia;
@synthesize triviaTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self setTriviaArray:[[movie trivias] allObjects]];
    currentTrivia = arc4random() % ([[self triviaArray] count] -1);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMusicTitleNotification:) name:@"MusicTitleFoundNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerDidExitFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    NSURL *fileURL = [NSURL URLWithString:[movie filePath]];
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    if (moviePlayer) {
        self.moviePlayerController = moviePlayer;
        [self installMovieNotificationObservers];
    }
    [self.moviePlayerController setControlStyle:MPMovieControlStyleEmbedded];
    [self.moviePlayerController setFullscreen:YES];
    [self.moviePlayerController prepareToPlay];
    [self.moviePlayerController setAllowsAirPlay:YES];
    
    //For viewing partially.....
    //[self.moviePlayerController.view setFrame:self.view.bounds];
    //self.moviePlayerController.backgroundView.backgroundColor = [UIColor blackColor];
    //[self.view addSubview:moviePlayer.view];  
    self.view = self.moviePlayerController.view;
    [self.moviePlayerController play];
    
    [self setLayerOverview:[[[NSBundle mainBundle] loadNibNamed:@"layerOverview" owner:self options:nil] lastObject]];
    self.layerOverview.frame = CGRectMake(934, 0, layerOverview.frame.size.width, layerOverview.frame.size.height);
    self.layerOverview.alpha = 0;
    [self.layerOverview setDelegate:self];
    [self.view addSubview:self.layerOverview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

         
#pragma mark Install Movie Notifications
         
        /* Register observers for the various movie object notifications. */
         -(void)installMovieNotificationObservers
        {
            MPMoviePlayerController *player = self.moviePlayerController;
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(loadStateDidChange:) 
                                                         name:MPMoviePlayerLoadStateDidChangeNotification 
                                                       object:player];
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(moviePlayBackDidFinish:) 
                                                         name:MPMoviePlayerPlaybackDidFinishNotification 
                                                       object:player];
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(mediaIsPreparedToPlayDidChange:) 
                                                         name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification 
                                                       object:player];
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(moviePlayBackStateDidChange:) 
                                                         name:MPMoviePlayerPlaybackStateDidChangeNotification 
                                                       object:player];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveMusicTitleNotification:)
                                                         name:@"MusicTitleFoundNotification"
                                                       object:player];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlayerDidExitFullscreen:)
                                                         name:MPMoviePlayerDidExitFullscreenNotification
                                                       object:player];
        }
         
#pragma mark Remove Movie Notification Handlers
         
        /* Remove the movie notification observers from the movie object. */
         -(void)removeMovieNotificationHandlers
        {    
            MPMoviePlayerController *player = [self moviePlayerController];
            
            [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MusicTitleFoundNotification" object:player];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:player];
        }


#pragma mark Movie Notification Handlers

/*  Notification called when the movie finished playing. */
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]; 
	switch ([reason integerValue]) 
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
            [self.navigationController popViewControllerAnimated:YES];
            [self removeMovieNotificationHandlers];
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback");
//            [self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:@"error"] 
//                                waitUntilDone:NO];
//            [self removeMovieViewFromViewHierarchy];
//            [self removeOverlayView];
//            [self.backgroundView removeFromSuperview];
//			break;
//            
            /* The user stopped playback. */
            [self.navigationController popViewControllerAnimated:YES];
            [self removeMovieNotificationHandlers];
            break;
		case MPMovieFinishReasonUserExited:
            [self.navigationController popViewControllerAnimated:YES];
            [self removeMovieNotificationHandlers];
			break;
            
		default:
            [self.navigationController popViewControllerAnimated:YES];
            [self removeMovieNotificationHandlers];
			break;
	}
}

/* Handle movie load state changes. */
- (void)loadStateDidChange:(NSNotification *)notification 
{   
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;	
    
	/* The load state is not known at this time. */
	if (loadState & MPMovieLoadStateUnknown)
	{
        
	}
	
	/* The buffer has enough data that playback can begin, but it 
	 may run out of data before playback finishes. */
	if (loadState & MPMovieLoadStatePlayable)
	{
	}
	
	/* Enough data has been buffered for playback to continue uninterrupted. */
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
	}
	
	/* The buffering of data has stalled. */
	if (loadState & MPMovieLoadStateStalled)
	{
	}
}

/* Called when the movie playback state has changed. */
- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    
	/* Playback is currently stopped. */
	if (player.playbackState == MPMoviePlaybackStateStopped) 
	{	}
	/*  Playback is currently under way. */
	else if (player.playbackState == MPMoviePlaybackStatePlaying) 
	{
        if (layerOverview.alpha > 0){

            [self fadeOutFaceViews];
            [self fadeOutMusicInfoViews];
            [self fadeOutTriviaInfoViews];
            [self toggleLayerOverview];
            
            if(triviaTimer)
            {
            [triviaTimer invalidate];
            triviaTimer = nil;
            }
        }
        [self setCurrentPauseTime:[NSNumber numberWithInt:-1]];
	}
	/* Playback is currently paused. */
	else if (player.playbackState == MPMoviePlaybackStatePaused && currentPauseTime.intValue < 0)
	{
            
        [self setCurrentPauseTime:[NSNumber numberWithDouble:player.currentPlaybackTime]];
        [self performSelectorInBackground:@selector(toggleLayerOverview) withObject:nil];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"faceRecognitionOn"]) {
            [self performSelectorInBackground:@selector(findFaces) withObject:nil];
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"triviaRecognitionOn"]) {
            [self performSelectorInBackground:@selector(fadeInTriviaInfoViews) withObject:nil];
            triviaTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(changeTrivia:) userInfo:nil repeats:YES];
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundRecognitionOn"]) {
            [self performSelectorInBackground:@selector(sendSoundPartForDecoding:) withObject:player];
        }

	}
	/* Playback is temporarily interrupted, perhaps because the buffer 
	 ran out of content. */
	else if (player.playbackState == MPMoviePlaybackStateInterrupted) 
	{
	}
}

- (void)moviePlayerDidExitFullscreen:(NSNotification *) notification
{
    [self.moviePlayerController stop];
    [self removeMovieNotificationHandlers];
    [self.moviePlayerController.view removeFromSuperview];
}

/* Notifies observers of a change in the prepared-to-play state of an object
 conforming to the MPMediaPlayback protocol. */
- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    
}

- (void) toggleLayerOverview
{
    if (self.layerOverview.alpha == 0){
        [self.layerOverview fadeIn:1 alpha:1 option:UIViewAnimationCurveEaseIn];
    }else{
        [self.layerOverview fadeOut:1 option:UIViewAnimationCurveEaseInOut removeFromSuperview:NO];
    }
}

#pragma mark -
#pragma mark Layer intelegence

#pragma mark Layer delegate methods

//switches on and off the face recognition. Releases the views when set off
- (void)faceRecognitionLayerOn:(BOOL) value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"faceRecognitionOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (value) {
        [self performSelectorInBackground:@selector(findFaces) withObject:nil];
    }else{
        [self fadeOutFaceViews];
    }
}
- (void)soundRecognitionLayerOn:(BOOL) value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"soundRecognitionOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (value) {
        [self performSelectorInBackground:@selector(sendSoundPartForDecoding:) withObject:self.moviePlayerController];
    }else{
        [self fadeOutMusicInfoViews];
    }
}
- (void)triviaLayerOn:(BOOL) value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"triviaRecognitionOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (value) {
        [self performSelectorInBackground:@selector(fadeInTriviaInfoViews) withObject:nil];
        triviaTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(changeTrivia:) userInfo:nil repeats:YES];
    }else{
        if(triviaTimer)
        {
            [triviaTimer invalidate];
            triviaTimer = nil;
        }
        [self fadeOutTriviaInfoViews];
    }
}

#pragma recognition methods

- (void)findFaces
{
    NSNumber *tempTime = [self currentPauseTime];
    faceViews = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIImage *image = [[self moviePlayerController] thumbnailImageAtTime:[self moviePlayerController].currentPlaybackTime timeOption:MPMovieTimeOptionExact];
    
    NSDictionary *options= [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                       forKey:CIDetectorAccuracy];
    CIDetector *detector =
    [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
    
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    NSArray *features = [detector featuresInImage:ciImage];
    
    // image is taken without letterbox. need to scale it later on
    float playerWidth = (float)[self moviePlayerController].view.bounds.size.width;
    float playerHeight = (float)[self moviePlayerController].view.bounds.size.height;
    float ratio = (float)image.size.width/(float)image.size.height;
    float diagonal = 1268; //sqrt(playerWidth*playerWidth + playerHeight*playerHeight); 
    float temp = (float) sqrtf((ratio*ratio)+1);
    float letterbox = (playerHeight - diagonal/temp)/2;
    float ratioWidth = playerWidth/(float)image.size.width;
    float ratioHeight = (playerHeight - letterbox*2)/(float)image.size.height;
    
    // CoreImage coordinate system origin is at the bottom left corner and UIKit's
    // is at the top left corner. So we need to translate features positions before
    // drawing them to screen. In order to do so we make an affine transform
    CGAffineTransform switchAxes = CGAffineTransformMakeScale(1, -1);
    //transform for MPPlayer (with letterboxes)
    CGAffineTransform transformInPlayerView = CGAffineTransformTranslate(switchAxes, 0, -self.view.bounds.size.height);
    //transform for plain image 
    CGAffineTransform transformInImage = CGAffineTransformTranslate(switchAxes, 0, -image.size.height);
    
    for (CIFaceFeature* facialFeature in features)
    {
        CGRect originalFaceRect = CGRectApplyAffineTransform(facialFeature.bounds, transformInImage);
        
        
        /////////////////////////
        //send images for recognition
        /////////////////////////
        
        // cut a bit more than just bounds
        originalFaceRect.size.width *= 1.3;
        originalFaceRect.size.height *= 1.3;
        originalFaceRect.origin.x -= originalFaceRect.size.width/6;
        originalFaceRect.origin.y -= originalFaceRect.size.height/6;
        
        // cut out face
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], originalFaceRect);
        UIImage *face = [UIImage imageWithCGImage:imageRef];
        
        NSString *name = [[DataManager sharedInstance] recognizeFace:face];
        name = [name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        
        /////////////////////////
        //highlight faces
        /////////////////////////
        
        CGRect scaledFaceRect = CGRectMake(facialFeature.bounds.origin.x*ratioWidth,facialFeature.bounds.origin.y*ratioHeight+letterbox,facialFeature.bounds.size.width*ratioWidth,facialFeature.bounds.size.height*ratioHeight);
        CGRect transformedFaceRect = CGRectApplyAffineTransform(scaledFaceRect, transformInPlayerView);
        
        CGRect faceViewRect = transformedFaceRect;
        faceViewRect.size.height += 20; //space for label
        UIView *faceView = [[UIView alloc] initWithFrame:faceViewRect];
        
        UIButton *faceViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, transformedFaceRect.size.width, transformedFaceRect.size.height)];
        [faceViewButton addTarget:self action:@selector(faceSelected:) forControlEvents:UIControlEventTouchUpInside];
        //little cheat to pass over attributes via title
        [faceViewButton setTitle:name forState:UIControlStateNormal];
        [faceViewButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [faceViewButton setAlpha:0.0];
        [[faceViewButton layer] setCornerRadius:15];
        [[faceViewButton layer] setBorderWidth:1];
        [[faceViewButton layer] setBorderColor:[UIColor cyanColor].CGColor];
        faceViewButton.backgroundColor = [UIColor clearColor];
        [faceView addSubview:faceViewButton];
        
        int labelWidth = 150;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((-labelWidth+transformedFaceRect.size.width)/2, transformedFaceRect.size.height, labelWidth, 20)];
        [nameLabel setAlpha:0.0];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setText:name];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:[UIColor grayColor]];
        [faceView addSubview:nameLabel];
        
        [[self moviePlayerController].view addSubview:faceView];
        if (tempTime == [self currentPauseTime] && [[self moviePlayerController] playbackState] == MPMoviePlaybackStatePaused) {
            [faceViews addObject:faceView];
            [faceViewButton fadeIn:1 alpha:0.7 option:UIViewAnimationOptionCurveEaseIn];
            [nameLabel fadeIn:1 alpha:1 option:UIViewAnimationOptionCurveEaseIn];
        }
    }
}

- (void)fadeOutFaceViews{
    for (UIView *faceView in faceViews) {
        [faceView fadeOut:1 option:UIViewAnimationCurveEaseIn removeFromSuperview:YES];
    }
    faceViews = nil;
}

- (void) faceSelected:(UIButton*) sender{
    NSString *name = sender.titleLabel.text;
       
    for (Actor *actor in [movie actors]) {
        //search for substring
        NSRange range = [name rangeOfString:actor.name options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            //show details
            
            ActorDetailsView *view = [[[NSBundle mainBundle] loadNibNamed:@"ActorDetailsView" owner:self options:nil] lastObject];
            [self.view addSubview:view];
            [view initWithActor:actor];
            
            [view fadeIn:0.5 alpha:1 option:UIViewAnimationOptionCurveEaseIn];
            return;
        }
    }
}

- (void)changeTrivia:(NSTimer *)timer
{
    [self fadeOutTriviaInfoViews];

    [self performSelector:@selector(fadeInTriviaInfoViews) withObject:nil afterDelay:2];
}

- (void)fadeInTriviaInfoViews
{
    //check if trivia on IMDB is available
    NSString *triviaText;
    if ([triviaArray count] > 0){
        triviaText = [[triviaArray objectAtIndex:currentTrivia] trivia];
        NSLog(@"%@",triviaText);
    }else {
        triviaText = @"No Trivia for you. Sorry!";
        if(triviaTimer)
        {
            [triviaTimer invalidate];
            triviaTimer = nil;
        }
    }
    
    CGSize triviaSize = [triviaText sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(700, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    
    funnyFactsView = [[UIView alloc] initWithFrame:CGRectMake((1024 - triviaSize.width)/2,610,triviaSize.width + 30,triviaSize.height+15)];
    [[funnyFactsView layer] setCornerRadius:15];
    [[funnyFactsView layer] setBorderWidth:1];
    funnyFactsView.alpha = 0.0;
    funnyFactsView.backgroundColor = [UIColor grayColor];
    
    UILabel *triviaLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, triviaSize.width, triviaSize.height)];
    
    triviaLabel.font = [UIFont systemFontOfSize:15.0f];
    triviaLabel.text = triviaText;
    
    triviaLabel.textAlignment =  UITextAlignmentCenter;

    triviaLabel.numberOfLines = 0;
    triviaLabel.lineBreakMode =UILineBreakModeWordWrap;
    triviaLabel.backgroundColor = [UIColor clearColor];

    
    [funnyFactsView addSubview:triviaLabel];
    
    if (currentTrivia == triviaArray.count-1) {
        currentTrivia = 0;
    }else{
        currentTrivia ++;
    }
    
    
    [[self moviePlayerController].view addSubview:funnyFactsView];
    [funnyFactsView fadeIn:1 alpha:0.7 option:UIViewAnimationOptionCurveEaseIn];
}

- (void)fadeOutTriviaInfoViews
{
    [funnyFactsView fadeOut:1 option:UIViewAnimationCurveEaseIn removeFromSuperview:YES];
}

- (void)sendSoundPartForDecoding:(MPMoviePlayerController *) player
{
    NSTimeInterval stopTime = [player currentPlaybackTime];
    float startTime = 0;
    float soundLength = 20;
    float endTime = soundLength;
    if (stopTime > 20){
        startTime = stopTime - soundLength/2;
        endTime = stopTime + soundLength/2;
    }
    if ((stopTime + soundLength/2) > player.duration){
        startTime = player.duration - soundLength;
        endTime = player.duration;
    }
    CMTime startTrimTime = CMTimeMakeWithSeconds(startTime, 1);
    CMTime endTrimTime = CMTimeMakeWithSeconds(endTime, 1);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTrimTime, endTrimTime);
    [[DataManager sharedInstance] recognizeSong:[NSURL URLWithString:[movie filePath]] inInterval:exportTimeRange withPauseTime:[self currentPauseTime]];
}

- (void)receiveMusicTitleNotification:(NSNotification *) notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *title = [userInfo objectForKey:@"title"];
    NSNumber *pauseTime = [userInfo objectForKey:@"time"];
    
    if (pauseTime == [self currentPauseTime] && [[self moviePlayerController] playbackState] == MPMoviePlaybackStatePaused) {
        [self performSelectorInBackground:@selector(fadeInMusicInfoViewWithTitle:) withObject:title];
    }

}

- (void)fadeInMusicInfoViewWithTitle: (NSString *) title
{
    currentMusicView = [[UIView alloc] initWithFrame:CGRectMake(724,50,250,70)];
    [[currentMusicView layer] setCornerRadius:15];
    [[currentMusicView layer] setBorderWidth:1];
    currentMusicView.alpha = 0.0;
    currentMusicView.backgroundColor = [UIColor grayColor];
    
    UILabel *musicLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 230, 60)];
    musicLabel.numberOfLines = 0;  // no restriction for title lines
    musicLabel.text = title;
    musicLabel.textAlignment =  UITextAlignmentCenter;
    musicLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    musicLabel.backgroundColor = [UIColor clearColor];
    [currentMusicView addSubview:musicLabel];
    
    [[self moviePlayerController].view addSubview:currentMusicView];
    [currentMusicView fadeIn:1 alpha:0.7 option:UIViewAnimationOptionCurveEaseIn];
}

- (void)fadeOutMusicInfoViews
{
    [currentMusicView fadeOut:1 option:UIViewAnimationCurveEaseIn removeFromSuperview:YES];
}

@end
