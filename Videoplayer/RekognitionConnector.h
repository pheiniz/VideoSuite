//
//  RekognitionConnector.h
//  Videoplayer
//
//  Created by Paul Heiniz on 9/22/12.
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "SBJson.h"

#define API_KEY @"kg75o82lBTFQTz5m"
#define API_SECRET @"7InVvA0U6pgFSuAg"
#define BASIS_URL @"http://rekognition.com/func/api/"



@interface RekognitionConnector : NSObject{
    
    SBJsonParser *parser;

}

+ (id)sharedInstance;

- (NSString *)recognizeFace:(UIImage *)image;

@end
