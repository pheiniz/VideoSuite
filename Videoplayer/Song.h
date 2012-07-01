//
//  Song.h
//  Videoplayer
//
//  Created by heiniz on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Soundtrack;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * lengthInSec;
@property (nonatomic, retain) NSString * amazonID;
@property (nonatomic, retain) NSString * itunesID;
@property (nonatomic, retain) Soundtrack *soundtrack;

@end
