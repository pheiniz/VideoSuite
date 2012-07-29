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

- (NSString *) stringForRuntime{
    return [rottenConnector stringForRuntime];
}

- (NSString *) stringForDescription{
    return [rottenConnector stringForDescription];
}

- (NSString *) stringForGenre{
    return [imdbConnector stringForGenre];
}

- (NSString *) stringForPoster{
    return [rottenConnector stringForPoster];
}

- (NSArray *) cast{
    return [rottenConnector cast];
}

- (NSMutableArray *) trivia{
    return [imdbConnector trivia];
}

@end
