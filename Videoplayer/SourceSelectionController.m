//
//  SourceSelectionController.m
//  Videoplayer
//
//  Created by heiniz on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SourceSelectionController.h"

@interface SourceSelectionController ()

@end

@implementation SourceSelectionController

@synthesize movies;
@synthesize selectedMovie;
@synthesize carousel;
@synthesize movieTitleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[DataManager sharedInstance] deleteDatabase];
    
    carousel.type = iCarouselTypeCoverFlow2;
    carousel.scrollSpeed = 0.5;
    
    [self loadData];
    
}

- (void)viewDidUnload
{
    [self setCarousel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

-(void)loadData
{
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeAnyVideo] forProperty:MPMediaItemPropertyMediaType];
    MPMediaQuery* query = [[MPMediaQuery alloc] init];
    [query addFilterPredicate:predicate];
    
    
    NSArray *arrayOfItems = [query items];
    
    movies = [[NSMutableArray alloc] init];
    
    
    for (MPMediaItem *mediaItem in arrayOfItems){
        NSURL *url = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        NSString *title = [self getMovieNameFromMetadataWithPath:[mediaItem valueForProperty:MPMediaItemPropertyAssetURL]];
        Movie* movie = [[DataManager sharedInstance] getMovie:title withPath:url];
        [movies addObject:movie];
    }
    
    [carousel reloadData];
    if (movies.count > 0) {
        [carousel scrollToItemAtIndex:0 animated:YES];
    }
}

-(NSString*) getMovieNameFromMetadataWithPath:(NSURL *) url
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *titles = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                            withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
    NSString *title = @"The Simpsons Movie";
    if (titles.count > 0) {
        AVMetadataItem *titleItem = (AVMetadataItem *)[titles objectAtIndex:0];
        title = (NSString *)titleItem.value;
    }
    return title;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [movies count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(MoviePreview *)view
{
    if (!view)
    {
    	//load new item view instance from nib
        //control events are bound to view controller in nib file
    	view = [[[NSBundle mainBundle] loadNibNamed:@"carouselItem" owner:self options:nil] lastObject];
        
        Movie *movie = [movies objectAtIndex:index];
        view.posterView.image = [UIImage imageWithData:[movie poster]];
        view.titleLabel.text = [movie title];
        view.genreLabel.text = [(Genre *)[movie.genres anyObject] name];
        
        [[view layer] setCornerRadius:15];
        [[view layer] setBorderWidth:1];
        
    }
    
    //NSString* movieTitle = [[moviesDictionary allKeys] objectAtIndex:index];
    NSString* movieTitle = [(Movie *)[movies objectAtIndex:index] title];
    [movieTitleLabel setText:movieTitle];
    
    return view;
}

- (void)carousel:(iCarousel *)car didSelectItemAtIndex:(NSInteger)index
{
    selectedMovie = [movies objectAtIndex:index];
    //NSString *name = selectedMovie.title;
    //[[DataConnector sharedInstance] setupMovie:name withPath:selectedMovie.filePath];
    [self performSegueWithIdentifier:@"SelectMovieSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController respondsToSelector:@selector(setMovie:)]) {
        [segue.destinationViewController performSelector:@selector(setMovie:) 
                                              withObject:selectedMovie];
    }
}

- (IBAction)refreshData:(UIButton *)sender {
    [self loadData];
}
@end
