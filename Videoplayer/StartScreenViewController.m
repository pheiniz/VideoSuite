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
@synthesize criticsLabel;
@synthesize audienceLabel;
@synthesize imdbLabel;
@synthesize yearLabel;
@synthesize runtimeLabel;
@synthesize genresLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString: [[RottenTomatoesConnector sharedInstance] stringForPoster]];
    [posterView setImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:url]]];
    [descriptionView setText:[[RottenTomatoesConnector sharedInstance] stringForDescription]];
    [[descriptionView layer] setCornerRadius:10];
    [[descriptionView layer] setBorderWidth:1];
    descriptionView.backgroundColor = [UIColor darkGrayColor];
    
    [criticsLabel setText:[[RottenTomatoesConnector sharedInstance] stringForCriticsRating]];
    [audienceLabel setText:[[RottenTomatoesConnector sharedInstance] stringForAudienceRating]];
    [imdbLabel setText:[[IMDBConnector sharedInstance] stringForIMDBRating]];
    [yearLabel setText:[[RottenTomatoesConnector sharedInstance] stringForReleaseYear]];
    [runtimeLabel setText:[[RottenTomatoesConnector sharedInstance] stringForRuntime]];
    [genresLabel setText:[[IMDBConnector sharedInstance] stringForGenre]];
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
- (IBAction)movieStart:(id)sender {
    
}
@end
