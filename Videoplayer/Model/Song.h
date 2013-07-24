//
//  Song.h
//  Videoplayer
//
//  Created by Paul Heiniz on 24/07/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Soundtrack;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * amazonID;
@property (nonatomic, retain) NSString * itunesID;
@property (nonatomic, retain) NSNumber * lengthInSec;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Soundtrack *soundtrack;

@end
