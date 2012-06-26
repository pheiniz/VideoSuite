//
//  RottenTomatoesConnector.m
//  Player
//
//  Created by heiniz on 04.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RottenTomatoesConnector.h"

#define APIKEY qwqdn6ue3qy6rxxscfc6xzca


@implementation RottenTomatoesConnector


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

- (void) connectToService{
    responseData = [NSMutableData data];  
    NSURLRequest *request = [NSURLRequest requestWithURL:  
                             [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=qwqdn6ue3qy6rxxscfc6xzca&q=Toy+Story+3&page_limit=1"]];  
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];

    NSMutableDictionary *jsonDict = [parser objectWithString:json_string error:nil];

    NSLog(@"%@ - %@", [[jsonDict objectForKey:@"links"] objectForKey:@"self"], [jsonDict objectForKey:@"total"]);
}

@end
