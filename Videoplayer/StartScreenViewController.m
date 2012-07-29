//
//  ViewController.m
//  Videoplayer
//
//  Created by heiniz on 05.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartScreenViewController.h"

@implementation StartScreenViewController
@synthesize posterView;
@synthesize descriptionView;
@synthesize actorsView;
@synthesize criticsLabel;
@synthesize audienceLabel;
@synthesize imdbLabel;
@synthesize yearLabel;
@synthesize runtimeLabel;
@synthesize genresLabel;
@synthesize movie;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft )];
    [self.view addGestureRecognizer:swipeLeft];
    
    [posterView setImage:[UIImage imageWithData:movie.poster]];
    [descriptionView setText:movie.plot];
    [[descriptionView layer] setCornerRadius:10];
    [[descriptionView layer] setBorderWidth:1];
    descriptionView.backgroundColor = [UIColor darkGrayColor];
    
    [[actorsView layer] setCornerRadius:10];
    [[actorsView layer] setBorderWidth:1];
    
    [criticsLabel setText:movie.rottenCriticRating];
    [audienceLabel setText:movie.rottenAudienceRating];
    [imdbLabel setText:movie.imdbRating];
    [yearLabel setText:movie.releaseDate];
    [runtimeLabel setText:[NSString stringWithFormat:@"Runtime: %d min", [movie.runningTimeInSec intValue]]];
    [genresLabel setText:[(Genre *)[movie.genres anyObject] name]];
}

- (void)viewDidUnload
{
    [self setPosterView:nil];
    [self setDescriptionView:nil];
    [self setCriticsLabel:nil];
    [self setAudienceLabel:nil];
    [self setImdbLabel:nil];
    [self setYearLabel:nil];
    [self setRuntimeLabel:nil];
    [self setGenresLabel:nil];
    [self setActorsView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController respondsToSelector:@selector(setMovie:)]) {
        [segue.destinationViewController performSelector:@selector(setMovie:) 
                                              withObject:movie];
    }
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:@"MoviePlay" sender:self];
}

@end
