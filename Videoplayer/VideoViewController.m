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

-(void)fadeInTriviaInfoViews;
-(void)fadeOutTriviaInfoViews;

-(void)fadeInMusicInfoViews;
-(void)fadeOutMusicInfoViews;
@end

@implementation VideoViewController

@synthesize moviePlayerController;
@synthesize funnyFactsView;
@synthesize currentMusicView;
@synthesize faceViews;
@synthesize movie;


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
    NSString *filePath = [movie filePath];
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:filePath]];
    if (moviePlayer) {
        [self setMoviePlayerController:moviePlayer];
        [self installMovieNotificationObservers];
    }
    [moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    [moviePlayer setFullscreen:YES];
    [moviePlayer prepareToPlay];
    [moviePlayer setAllowsAirPlay:YES];
    
    //For viewing partially.....
    [moviePlayer.view setFrame:self.view.bounds];
    moviePlayer.backgroundView.backgroundColor = [UIColor blackColor]; 
    //[self.view addSubview:moviePlayer.view];  
    self.view = moviePlayer.view;
    [moviePlayer play]; 
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
            MPMoviePlayerController *player = [self moviePlayerController];
            
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
		case MPMovieFinishReasonUserExited:
            [self.navigationController popViewControllerAnimated:YES];
			break;
            
		default:
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
        if (funnyFactsView){
            [self fadeOutTriviaInfoViews];
            [self fadeOutMusicInfoViews];
            [self fadeOutFaceViews];
        }
	}
	/* Playback is currently paused. */
	else if (player.playbackState == MPMoviePlaybackStatePaused) 
	{
        [self performSelectorInBackground:@selector(findFaces) withObject:nil];
        [self fadeInTriviaInfoViews];
        [self fadeInMusicInfoViews];
	}
	/* Playback is temporarily interrupted, perhaps because the buffer 
	 ran out of content. */
	else if (player.playbackState == MPMoviePlaybackStateInterrupted) 
	{
	}
}

/* Notifies observers of a change in the prepared-to-play state of an object 
 conforming to the MPMediaPlayback protocol. */
- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    
}

-(void)findFaces
{
    faceViews = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIImage *image = [moviePlayerController thumbnailImageAtTime:moviePlayerController.currentPlaybackTime timeOption:MPMovieTimeOptionExact];
    
    NSDictionary *options= [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                       forKey:CIDetectorAccuracy];
    CIDetector *detector =
    [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
    
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    NSArray *features = [detector featuresInImage:ciImage];
    
    float playerWidth = (float)moviePlayerController.view.bounds.size.width;
    float playerHeight = (float)moviePlayerController.view.bounds.size.height;
    float ratio = (float)image.size.width/(float)image.size.height;
    float diagonal = 1268; //sqrt(playerWidth*playerWidth + playerHeight*playerHeight); 
    float temp = (float) sqrtf((ratio*ratio)+1);
    float letterbox = (playerHeight - diagonal/temp)/2;
    float ratioWidth = playerWidth/(float)image.size.width;
    float ratioHeight = (playerHeight - letterbox*2)/(float)image.size.height;
    
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -self.view.bounds.size.height);
    
    for (CIFaceFeature* facialFeature in features)
    {
        CGRect faceRect = CGRectMake(facialFeature.bounds.origin.x*ratioWidth,facialFeature.bounds.origin.y*ratioHeight+letterbox,facialFeature.bounds.size.width*ratioWidth,facialFeature.bounds.size.height*ratioHeight);
        faceRect = CGRectApplyAffineTransform(faceRect, transform);
        UIView *faceView = [[UIView alloc] initWithFrame:faceRect];
        faceView.alpha = 0.0;
        [[faceView layer] setCornerRadius:15];
        [[faceView layer] setBorderWidth:3];
        [[faceView layer] setBorderColor:[UIColor cyanColor].CGColor];
        faceView.backgroundColor = [UIColor clearColor];  
        [moviePlayerController.view addSubview:faceView];
        [faceViews addObject:faceView];
        [faceView fadeIn:1 alpha:0.7 option:UIViewAnimationOptionCurveEaseIn];      
    }  
}

-(void)fadeOutFaceViews{
    for (UIView *faceView in faceViews) {
        [faceView fadeOut:1 option:UIViewAnimationCurveEaseIn];
    }
    faceViews = nil;
}

- (void)fadeInTriviaInfoViews
{
    funnyFactsView = [[UIView alloc] initWithFrame:CGRectMake(312,610,400,70)];
    [[funnyFactsView layer] setCornerRadius:15];
    [[funnyFactsView layer] setBorderWidth:1];
    funnyFactsView.alpha = 0.0;
    funnyFactsView.backgroundColor = [UIColor grayColor];
    
    UILabel *triviaLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 340, 70)];
    
    triviaLabel.font = [UIFont fontWithName:@"Arial Rounded MT" size:(20.0)];
    NSArray * triviaArray = [[IMDBConnector sharedInstance] trivia];
    //check if trivia on IMDB is available
    if ([triviaArray count]>0){
        NSString *triviaText = [[triviaArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        triviaLabel.text = triviaText;
        if (triviaText.length > 120){
            triviaLabel.font = [UIFont fontWithName:@"Arial Rounded MT" size:(14.0)];
        }
    }else {
        triviaLabel.text = @"No Trivia for you. Sorry!";
    }
    
    triviaLabel.textAlignment =  UITextAlignmentCenter;
    CGRect currentFrame = triviaLabel.frame;
    CGSize max = CGSizeMake(triviaLabel.frame.size.width, 500);
    CGSize expected = [triviaLabel.text sizeWithFont:triviaLabel.font constrainedToSize:max lineBreakMode:triviaLabel.lineBreakMode]; 
    currentFrame.size.height = expected.height;
    triviaLabel.frame = currentFrame;
    triviaLabel.numberOfLines = 0;
    triviaLabel.lineBreakMode =UILineBreakModeWordWrap;
    triviaLabel.backgroundColor = [UIColor clearColor];

    
    [funnyFactsView addSubview:triviaLabel];
    
    [moviePlayerController.view addSubview:funnyFactsView];
    [funnyFactsView fadeIn:1 alpha:0.7 option:UIViewAnimationOptionCurveEaseIn];
}

- (void)fadeOutTriviaInfoViews
{
    [funnyFactsView fadeOut:1 option:UIViewAnimationCurveEaseIn];
}

- (void)fadeInMusicInfoViews
{
    currentMusicView = [[UIView alloc] initWithFrame:CGRectMake(824,50,180,30)];
    [[currentMusicView layer] setCornerRadius:15];
    [[currentMusicView layer] setBorderWidth:1];
    currentMusicView.alpha = 0.0;
    currentMusicView.backgroundColor = [UIColor grayColor];
    
    UILabel *musicLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 140, 22)];
    musicLabel.text = @"Music will be here soon";
    musicLabel.textAlignment =  UITextAlignmentCenter;
    musicLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
    musicLabel.backgroundColor = [UIColor clearColor];
    [currentMusicView addSubview:musicLabel];
    
    [moviePlayerController.view addSubview:currentMusicView];
    [currentMusicView fadeIn:1 alpha:0.7 option:UIViewAnimationOptionCurveEaseIn];
}

- (void)fadeOutMusicInfoViews
{
    [currentMusicView fadeOut:1 option:UIViewAnimationCurveEaseIn];
}

@end
