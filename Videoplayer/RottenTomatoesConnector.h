//
//  RottenTomatoesConnector.h
//  Player
//
//  Created by heiniz on 04.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"


@interface RottenTomatoesConnector : NSObject {
    NSMutableData *responseData;  
    SBJsonParser *parser;
}

+ (id)sharedInstance;
- (void) connectToService;
@end
