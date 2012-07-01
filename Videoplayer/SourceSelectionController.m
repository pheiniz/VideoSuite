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

@synthesize moviesDictionary;
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
    carousel.type = iCarouselTypeCoverFlow2;
    carousel.scrollSpeed = 0.5;
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    moviesDictionary = [[NSMutableDictionary alloc] init];
    for (NSString *filename in fileList){
        NSLog(@"%@", filename);
        if ([filename hasSuffix:@".mov"]||
            [filename hasSuffix:@".mp4"]||
            [filename hasSuffix:@".m4v"]||
            [filename hasSuffix:@".3gp"]){
            NSString* title = [self getMovieNameFromMetadataWithPath:[documentsDirectory stringByAppendingPathComponent:filename]];
            [moviesDictionary setObject:filename forKey:title];
        }
    }
    
    [carousel reloadData];
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

-(NSString*) getMovieNameFromMetadataWithPath:(NSString *) path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *titles = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                            withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
    AVMetadataItem *title = (AVMetadataItem *)[titles objectAtIndex:0];
    return (NSString *)title.value;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [moviesDictionary count];
}

//- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
//{
//    //return the number of visible carousel items on screen
//    //this also affects the appearance of circular-type carousels
//    //this value should be <= numberOfItemsInCarousel
//    //if you have fewer than about 25 items in your carousel, you don't need
//    //to use this method at all (by default it matches numberOfItemsInCarousel)
//    return 2;
//}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
    	//load new item view instance from nib
        //control events are bound to view controller in nib file
    	view = [[[NSBundle mainBundle] loadNibNamed:@"carouselItem" owner:self options:nil] lastObject];
    }
    
    NSString* movieTitle = [[moviesDictionary allKeys] objectAtIndex:index];
    [movieTitleLabel setText:movieTitle];
    
    return view;
}

- (void)carousel:(iCarousel *)car didSelectItemAtIndex:(NSInteger)index
{
    UIView *view = [carousel itemViewAtIndex:index];
    
    UILabel *nameLabel = (UILabel*)[view viewWithTag:10];  //very very very dirty. Change that!
    
    NSString *name = nameLabel.text;
    [[DataConnector sharedInstance] setupMovie:name withPath:[moviesDictionary objectForKey:name]];
    [self performSegueWithIdentifier:@"SelectMovieSegue" sender:self];
}

@end
