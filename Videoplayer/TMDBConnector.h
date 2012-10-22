//
//  TMDBConnector.h
//  Videoplayer
//
//  Created by Paul Heiniz on 7/31/12.
//
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "Actor.h"

#define TMDB_APIKEY @"api_key=f9a2bc88494903a20a8286736aaa7222"
#define BASEPATH @"http://cf2.imgobject.com/t/p/"
#define PROFILESIZESMALL @"w45"
#define PROFILESIZEMEDIUM @"w185"
#define PROFILESIZEORIGINAL @"original"

@interface TMDBConnector : NSObject{
    SBJsonParser *parser;
}

@property (nonatomic, retain) NSString *movieTitle;
@property (retain) NSString *tmdbMovieID;


+ (id)sharedInstance;
- (void) connectToServiceForMovie:(NSString *)movieTitle;
- (NSArray *) cast;
- (NSDictionary *) infoForActor:(NSString *) tmdbPersonID;
- (NSNumber *) stringForRuntime;

@end