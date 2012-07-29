//
//  Actor.h
//  Videoplayer
//
//  Created by Paul Heiniz on 7/28/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Actor : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * rottenID;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSSet *movies;
@end

@interface Actor (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

@end
