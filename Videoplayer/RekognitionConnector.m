//
//  RekognitionConnector.m
//  Videoplayer
//
//  Created by Paul Heiniz on 9/22/12.
//
//

#import "RekognitionConnector.h"

@implementation RekognitionConnector


static RekognitionConnector *sharedInstance = nil;



// Get the shared instance and create it if necessary.
+ (RekognitionConnector *)sharedInstance {
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

- (NSString *)recognizeFace:(UIImage *)image
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:BASIS_URL]];
    [request setPostValue:API_KEY forKey:@"api_key"];
    [request setPostValue:API_SECRET forKey:@"api_secret"];
    [request setPostValue:@"face_recognize" forKey:@"jobs"];
    [request setPostValue:@"abcd" forKey:@"name_space"];
    [request setPostValue:@"xyz" forKey:@"user_id"];
    
    [request setData:UIImagePNGRepresentation(image) forKey:@"uploaded_file"];
    
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = @"";
    if (!error) {
        response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary *json = [parser objectWithString:response error:nil];
        //recognized faces
        NSArray *faces = [json objectForKey:@"face_detection"];
        
        //we always send one face, thus check for not empty
        if (faces.count > 0) {
            response = [[[[faces objectAtIndex:0]objectForKey:@"name"] componentsSeparatedByString:@","] objectAtIndex:0];
            
        }
        
    }
    
    return response;
}
@end
