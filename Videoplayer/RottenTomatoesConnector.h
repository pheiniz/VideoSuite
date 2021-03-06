//
//  RottenTomatoesConnector.h
//  Player
//
//  Created by heiniz on 04.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

#define ROTTEN_APIKEY @"YOURKEYHERE"

@interface RottenTomatoesConnector : NSObject {
    SBJsonParser *parser;
}

@property (nonatomic, retain) NSString *movieTitle;
@property (retain) NSString *movieID;
@property (retain) NSMutableDictionary *jsonDict;

+ (id)sharedInstance;
- (void) connectToServiceForMovie:(NSString *)movieTitle;
- (void) createDetailDictionary;
- (NSString *) stringForPoster;
- (NSString *) stringForDescription;
- (NSString *) stringForCriticsRating;
- (NSString *) stringForAudienceRating;
- (NSString *) stringForReleaseYear;
- (NSString *) stringForRuntime;
- (NSString *) stringForIMDBID;
- (NSArray *) cast;


@end
