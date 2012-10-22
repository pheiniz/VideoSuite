//
//  EchoprintConnector.m
//  Videoplayer
//
//  Created by Paul Heiniz on 8/23/12.
//
//

#import "EchoprintConnector.h"

@implementation EchoprintConnector
static EchoprintConnector *sharedInstance = nil;



// Get the shared instance and create it if necessary.
+ (EchoprintConnector *)sharedInstance {
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

- (NSString *) connectToServiceForSongCode:(const char *)code{
    NSString *song = @"no match";
	NSString *url = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/song/identify?api_key=%@&version=4.12&code=%s",ECHO_KEY, code];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:url]];
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *json = [parser objectWithString:json_string error:nil];
    
    NSArray *songList = [[json objectForKey:@"response"] objectForKey:@"songs"];
    if ([songList count] > 0){
        NSString * song_title = [[songList objectAtIndex:0] objectForKey:@"title"];
        NSString * artist_name = [[songList objectAtIndex:0] objectForKey:@"artist_name"];
        song = [NSString stringWithFormat:@"%@ \nby %@", song_title, artist_name];
    }
    
    return song;
}

@end
