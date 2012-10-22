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
    NSString *rating = [jsonDict objectForKey:@"rating"];
    return [NSString stringWithFormat:@"%@", rating];
}

- (NSString *) stringForGenre{
    NSString *genres = [jsonDict objectForKey:@"genres"];
    return [NSString stringWithFormat:@"%@", genres];
}

- (NSMutableArray *) triviaForMovie:(NSString *) imdbID{
    
    NSMutableArray *trivias = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *imdbPage = [NSString stringWithFormat:@"http://www.imdb.com/title/tt%@/trivia", imdbID];
    NSURL *imdbMovieUrl = [NSURL URLWithString:imdbPage];
    
    HTMLParser *htmlparser = [[HTMLParser alloc] initWithContentsOfURL:imdbMovieUrl error:nil];
    HTMLNode *bodyNode = [htmlparser body];
    
    NSArray *inputNodes = [bodyNode findChildTags:@"div"];
    
    for (HTMLNode *node in inputNodes) {
        if ([[node getAttributeNamed:@"class"] isEqualToString:@"sodatext"]) {

            [trivias addObject:[node allContents]];
        }
    }
    return trivias;
}

- (NSString *) descriptionForMovie:(NSString *) imdbID{
    
    //NSMutableArray *trivias = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *imdbPage = [NSString stringWithFormat:@"http://www.imdb.com/title/tt%@/plotsummary", imdbID];
    NSURL *imdbMovieUrl = [NSURL URLWithString:imdbPage];
    
    HTMLParser *htmlparser = [[HTMLParser alloc] initWithContentsOfURL:imdbMovieUrl error:nil];
    HTMLNode *bodyNode = [htmlparser body];
    
    NSArray *inputNodes = [bodyNode findChildTags:@"p"];
    
    for (HTMLNode *node in inputNodes) {
        if ([[node getAttributeNamed:@"class"] isEqualToString:@"plotpar"]) {
            
            NSString *nodeContent = [node allContents];
            NSRange rangeOfSubstring = [nodeContent rangeOfString:@"\n Written"];
            if(rangeOfSubstring.location != NSNotFound)
            {
                return [nodeContent substringToIndex:rangeOfSubstring.location];
            }
            return nodeContent;
            
        }
    }
    return @"This movie has no story! Sad :(";
}

- (void) connectToServiceForMovie:(NSString *)title{
    [self setMovieTitle:title];
    NSString *informationLink = [NSString stringWithFormat:@"http://www.deanclatworthy.com/imdb/?q=%@", [title stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:  
                             [NSURL URLWithString:informationLink]];  
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *json = [parser objectWithString:json_string error:nil];
    
    [self setImdbMovieID:[json objectForKey:@"imdbid"]];
    [self setJsonDict:json];
}


@end
