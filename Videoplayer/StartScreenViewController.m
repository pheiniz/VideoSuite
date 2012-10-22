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
@synthesize castArray;

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

    //order cast members to display them in the right order
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    castArray = [[movie.actors allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    
    [actorsView refreshData];
    
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

- (NSInteger)numberOfColumnsForTableView:(HorizontalTableView *)tableView {
    return [movie.actors count];
}

- (UIView *)tableView:(HorizontalTableView *)aTableView viewForIndex:(NSInteger)index {
    
    ActorView *vw;// = (ActorView *)[aTableView dequeueColumnView];
        
        vw = [[[NSBundle mainBundle] loadNibNamed:@"actorItem" owner:self options:nil] lastObject];
        Actor *actor = (Actor *)[castArray objectAtIndex:index];
        vw.actorPicture.image = [UIImage imageWithData:[actor picture]];
        vw.nameLabel.text = [NSString stringWithFormat:@"%@\nas\n%@", [actor name], [actor character]];
	return vw;
}

- (CGFloat)columnWidthForTableView:(HorizontalTableView *)tableView {
    return 150.0f;
}

- (void)tableView:(HorizontalTableView *)tableView didSelectItemAtIndex:(NSInteger)index
{
    Actor *actor = [castArray objectAtIndex:index];
    //show details
    
    ActorDetailsView *view;
    
    view = [[[NSBundle mainBundle] loadNibNamed:@"ActorDetailsView" owner:self options:nil] lastObject];
    [self.view addSubview:view];
    [view initWithActor:actor];
    
    [view fadeIn:0.5 alpha:1 option:UIViewAnimationOptionCurveEaseIn];
}


@end
