//
//  DataConnector.h
//  Videoplayer
//
//  Created by heiniz on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMDBConnector.h"
#import "RottenTomatoesConnector.h"

@interface DataConnector : NSObject

@property (retain) NSString *movieTitle;
@property (retain) NSURL *movieURL;
@property (retain) IMDBConnector *imdbConnector;
@property (retain) RottenTomatoesConnector *rottenConnector;

+ (id)sharedInstance;
- (void)setupMovie:(NSString*) movieTitle withPath:(NSURL *) movieURL;

- (NSString *)stringForIMDBRating;
- (NSString *) stringForCriticsRating;
- (NSString *) stringForAudienceRating;
- (NSString *) stringForReleaseYear;
- (NSString *) stringForRuntime;
- (NSString *) stringForDescription;
- (NSString *) stringForGenre;
- (NSString *) stringForPoster;
- (NSMutableArray *) trivia;
- (NSArray *) cast;


@end
