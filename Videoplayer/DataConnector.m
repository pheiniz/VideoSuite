//
//  DataConnector.m
//  Videoplayer
//
//  Created by heiniz on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataConnector.h"

@implementation DataConnector

@synthesize movieTitle;
@synthesize movieURL;
@synthesize imdbConnector;
@synthesize rottenConnector;
@synthesize tmdbConnector;
@synthesize echoprintConnector;
@synthesize rekognitionConnector;

static DataConnector *sharedInstance = nil;



// Get the shared instance and create it if necessary.
+ (DataConnector *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        imdbConnector = [IMDBConnector sharedInstance];
        rottenConnector = [RottenTomatoesConnector sharedInstance];
        tmdbConnector = [TMDBConnector sharedInstance];
        echoprintConnector = [EchoprintConnector sharedInstance];
        rekognitionConnector = [RekognitionConnector sharedInstance];
    }
    
    return self;
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

- (void)setupMovie:(NSString*)title withPath:(NSURL *) url
{
    [self setMovieTitle:title];
    [self setMovieURL:url];
    [[IMDBConnector sharedInstance] connectToServiceForMovie:title];
    [[RottenTomatoesConnector sharedInstance] connectToServiceForMovie:title];
    [[TMDBConnector sharedInstance] connectToServiceForMovie:title];
}

#pragma mark - Information methods

- (NSString *)stringForIMDBRating{
    return [imdbConnector stringForIMDBRating];
}

- (NSString *) stringForCriticsRating{
    return [rottenConnector stringForCriticsRating];
}

- (NSString *) stringForAudienceRating{
    return [rottenConnector stringForAudienceRating];
}

- (NSString *) stringForReleaseYear{
    return [rottenConnector stringForReleaseYear];
}

- (NSNumber *) stringForRuntime{
    return [tmdbConnector stringForRuntime];
}

- (NSString *) stringForDescription{
    return [imdbConnector descriptionForMovie:[rottenConnector stringForIMDBID]];
}

- (NSString *) stringForGenre{
    return [imdbConnector stringForGenre];
}

- (NSString *) stringForPoster{
    return [rottenConnector stringForPoster];
}

- (NSArray *) cast{
    return [tmdbConnector cast];
}

- (NSDictionary *) infoForActor:(NSString *) tmdbPersonID{
    return [tmdbConnector infoForActor:tmdbPersonID];
}

- (NSMutableArray *) trivia{
    return [imdbConnector triviaForMovie:[rottenConnector stringForIMDBID]];
}

- (NSString *) recognizeSongFromCode:(const char *)code{
    return [echoprintConnector connectToServiceForSongCode:code];
}

- (NSString *)recognizeFace:(UIImage *)image{
    return [rekognitionConnector recognizeFace:image];
}

@end
