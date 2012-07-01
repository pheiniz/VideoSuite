//
//  Soundtrack.h
//  Videoplayer
//
//  Created by heiniz on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Soundtrack : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * amazonID;
@property (nonatomic, retain) NSString * itunesID;
@property (nonatomic, retain) NSSet *songs;
@property (nonatomic, retain) NSManagedObject *movie;
@end

@interface Soundtrack (CoreDataGeneratedAccessors)

- (void)addSongsObject:(NSManagedObject *)value;
- (void)removeSongsObject:(NSManagedObject *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
