//
//  TMDBConnector.m
//  Videoplayer
//
//  Created by Paul Heiniz on 7/31/12.
//
//

#import "TMDBConnector.h"

@implementation TMDBConnector

@synthesize movieTitle;

static TMDBConnector *sharedInstance = nil;



// Get the shared instance and create it if necessary.
+ (TMDBConnector *)sharedInstance {
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

- (NSArray *) cast{
    
    NSString *informationLink = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@/casts?%@", [self tmdbMovieID],TMDB_APIKEY];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:informationLink]];
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *json = [parser objectWithString:json_string error:nil];
    
    NSArray * castShort = [json objectForKey:@"cast"];
    NSMutableArray* cast = [[NSMutableArray alloc] initWithCapacity:[castShort count]];
    
    for (NSDictionary *actorJSON in castShort) {
        NSString* tmdbPersonID = [actorJSON objectForKey:@"id"];
        NSString* character = [actorJSON objectForKey:@"character"];
        NSMutableDictionary* actor = [NSMutableDictionary dictionaryWithDictionary:[self infoForActor:tmdbPersonID]];
        [actor setObject:character forKey:@"character"];
        [cast addObject:actor];
    }
    
    return cast;
}

- (NSDictionary *) infoForActor:(NSString *) tmdbPersonID{
    NSString *informationLink = [NSString stringWithFormat:@"http://api.themoviedb.org/3/person/%@?%@", tmdbPersonID,TMDB_APIKEY];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:informationLink]];
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    return [parser objectWithString:json_string error:nil];
}

- (NSNumber *) stringForRuntime{
    NSString *informationLink = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@?%@", self.tmdbMovieID,TMDB_APIKEY];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:informationLink]];
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSDictionary *movieData = [parser objectWithString:json_string error:nil];
    NSNumber *runtime = [movieData objectForKey:@"runtime"];
    return runtime;
}

- (void) connectToServiceForMovie:(NSString *)title{
    
    NSString *informationLink = [NSString stringWithFormat:@"http://api.themoviedb.org/3/search/movie?%@&query=%@", TMDB_APIKEY, [title stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:informationLink]];
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *json = [parser objectWithString:json_string error:nil];
    
    NSArray *moviesArray = [json objectForKey:@"results"];
    NSDictionary *firstMovie = [moviesArray objectAtIndex:0];
    [self setTmdbMovieID:[firstMovie objectForKey:@"id"]];
    [self setMovieTitle:[firstMovie objectForKey:@"title"]];
}


@end
