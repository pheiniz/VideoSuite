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
@property (retain) NSString *moviePath;

+ (id)sharedInstance;
- (void)setupMovie:(NSString*) movieTitle withPath:(NSString *) moviePath;

@end
