//
//  IMDBConnector.h
//  Videoplayer
//
//  Created by heiniz on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface IMDBConnector : NSObject{
        SBJsonParser *parser;
}

@property (nonatomic, retain) NSString *movieTitle;
@property (retain) NSString *imdbMovieID;
@property (retain) NSMutableDictionary *jsonDict;

+ (id)sharedInstance;
- (void) connectToServiceForMovie:(NSString *)movieTitle;
- (NSString *) stringForIMDBRating;
- (NSString *) stringForGenre;
@end
