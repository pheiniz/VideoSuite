//
//  Soundtrack.h
//  Videoplayer
//
//  Created by Paul Heiniz on 24/07/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, Song;

@interface Soundtrack : NSManagedObject

@property (nonatomic, retain) NSString * amazonID;
@property (nonatomic, retain) NSString * itunesID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Movie *movie;
@property (nonatomic, retain) NSSet *songs;
@end

@interface Soundtrack (CoreDataGeneratedAccessors)

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
