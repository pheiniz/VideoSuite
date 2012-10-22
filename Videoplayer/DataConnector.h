//
//  DataConnector.h
//  Videoplayer
//
//  Created by heiniz on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMDBConnector.h"
#import "TMDBConnector.h"
#import "RottenTomatoesConnector.h"
#import "EchoprintConnector.h"
#import "RekognitionConnector.h"

@interface DataConnector : NSObject

@property (retain) NSString *movieTitle;
@property (retain) NSURL *movieURL;
@property (retain) IMDBConnector *imdbConnector;
@property (retain) RottenTomatoesConnector *rottenConnector;
@property (retain) TMDBConnector *tmdbConnector;
@property (retain) EchoprintConnector *echoprintConnector;
@property (retain) RekognitionConnector *rekognitionConnector;

+ (id)sharedInstance;
- (void)setupMovie:(NSString*) movieTitle withPath:(NSURL *) movieURL;

- (NSString *)stringForIMDBRating;
- (NSString *) stringForCriticsRating;
- (NSString *) stringForAudienceRating;
- (NSString *) stringForReleaseYear;
- (NSNumber *) stringForRuntime;
- (NSString *) stringForDescription;
- (NSString *) stringForGenre;
- (NSString *) stringForPoster;
- (NSMutableArray *) trivia;
- (NSArray *) cast;
- (NSDictionary *) infoForActor:(NSString *) tmdbPersonID;
- (NSString *) recognizeSongFromCode:(const char *)code;
- (NSString *)recognizeFace:(UIImage *)image;

@end
