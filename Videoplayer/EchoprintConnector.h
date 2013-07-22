//
//  EchoprintConnector.h
//  Videoplayer
//
//  Created by Paul Heiniz on 8/23/12.
//
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

#define ECHO_KEY @"YOURKEYHERE"


@interface EchoprintConnector : NSObject {
    SBJsonParser *parser;
}

+ (id)sharedInstance;

- (NSString *) connectToServiceForSongCode:(const char *)code;

@end
