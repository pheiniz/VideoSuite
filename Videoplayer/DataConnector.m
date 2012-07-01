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
@synthesize moviePath;

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
    }
    
    return self;
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

- (void)setupMovie:(NSString*)title withPath:(NSString *) path
{
    [self setMovieTitle:title];
    [self setMoviePath:path];
    [[IMDBConnector sharedInstance] connectToServiceForMovie:title];
    [[RottenTomatoesConnector sharedInstance] connectToServiceForMovie:title];
}

@end
