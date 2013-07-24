//
//  Actor.h
//  Videoplayer
//
//  Created by Paul Heiniz on 24/07/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Actor : NSManagedObject

@property (nonatomic, retain) NSString * actorID;
@property (nonatomic, retain) NSString * biography;
@property (nonatomic, retain) NSString * birthdate;
@property (nonatomic, retain) NSString * birthplace;
@property (nonatomic, retain) NSString * character;
@property (nonatomic, retain) NSString * homepage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSSet *movies;
@end

@interface Actor (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

@end
