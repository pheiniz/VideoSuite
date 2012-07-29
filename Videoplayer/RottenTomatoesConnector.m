//
//  RottenTomatoesConnector.m
//  Player
//
//  Created by heiniz on 04.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RottenTomatoesConnector.h"

@implementation RottenTomatoesConnector

@synthesize movieTitle;
@synthesize movieID;
@synthesize jsonDict;

static RottenTomatoesConnector *sharedInstance = nil;



// Get the shared instance and create it if necessary.
+ (RottenTomatoesConnector *)sharedInstance {
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

- (NSString *) stringForPoster{
    
        NSLog(@"%@", [[jsonDict objectForKey:@"posters"] objectForKey:@"original"]);
    return [[jsonDict objectForKey:@"posters"] objectForKey:@"original"];
}

- (NSString *) stringForDescription{
    NSString *description = [NSString stringWithString:[jsonDict objectForKey:@"synopsis"]];
    return description;
}

- (NSString *) stringForAudienceRating{
    NSString *rating = [[jsonDict objectForKey:@"ratings"] objectForKey:@"audience_rating"];
    NSString *score = [[jsonDict objectForKey:@"ratings"] objectForKey:@"audience_score"];
    return [NSString stringWithFormat:@"%@: %@%%", rating, score];
}

- (NSString *) stringForCriticsRating{ 
    NSString *rating = [[jsonDict objectForKey:@"ratings"] objectForKey:@"critics_rating"];
    NSString *score = [[jsonDict objectForKey:@"ratings"] objectForKey:@"critics_score"];
    return [NSString stringWithFormat:@"%@: %@%%", rating, score];
}

- (NSString *) stringForReleaseYear{ 
    NSNumber *nr = [jsonDict objectForKey:@"year"];
    NSString *year = [NSString stringWithFormat:@"Release: %i", nr.intValue];
    return year;
}

- (NSNumber *) stringForRuntime{ 
    NSNumber *runtime = [jsonDict objectForKey:@"runtime"];
    return runtime;
}

- (NSArray *) cast{
    NSArray * cast = [jsonDict objectForKey:@"abridged_cast"];
    return cast;
}

- (void) connectToServiceForMovie:(NSString *)title{
    [self setMovieTitle:title];
    NSString *informationLink = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=%@&q=%@&page_limit=1", APIKEY, [title stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:  
                             [NSURL URLWithString:informationLink]];  
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];

    NSMutableDictionary *json = [parser objectWithString:json_string error:nil];
    
    NSArray *movieData = [json objectForKey:@"movies"];
    
    NSMutableDictionary *movieDict = [movieData objectAtIndex:0];
    
    [self setMovieID:[movieDict objectForKey:@"id"]];
    [self createDetailDictionary];
}

- (void) createDetailDictionary{
    NSString *informationLink = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@.json?apikey=%@",movieID , APIKEY];
    NSURLRequest *request = [NSURLRequest requestWithURL:  
                             [NSURL URLWithString:informationLink]];
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    [self setJsonDict:[parser objectWithString:json_string error:nil]];
}

@end
