//
//  IMDBConnector.m
//  Videoplayer
//
//  Created by heiniz on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IMDBConnector.h"

@implementation IMDBConnector

@synthesize movieTitle;
@synthesize imdbMovieID;
@synthesize jsonDict;

static IMDBConnector *sharedInstance = nil;



// Get the shared instance and create it if necessary.
+ (IMDBConnector *)sharedInstance {
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
        parser = [[SBJsonParser alloc] init];
    }
    
    return self;
}


// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

- (NSString *) stringForIMDBRating{
    NSString *rating = [jsonDict objectForKey:@"imdbRating"];
    return [NSString stringWithFormat:@"%@", rating];
}

- (NSString *) stringForGenre{
    NSString *genres = [jsonDict objectForKey:@"Genre"];
    return [NSString stringWithFormat:@"Genres: %@", genres];
}

- (void) connectToServiceForMovie:(NSString *)title{
    [self setMovieTitle:title];
    NSString *informationLink = [NSString stringWithFormat:@"http://www.imdbapi.com/?t=%@", [title stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:  
                             [NSURL URLWithString:informationLink]];  
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *json = [parser objectWithString:json_string error:nil];
    
    [self setImdbMovieID:[json objectForKey:@"imdbID"]];
    [self setJsonDict:json];
}

@end
