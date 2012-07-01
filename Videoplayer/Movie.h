//
//  Movie.h
//  Videoplayer
//
//  Created by heiniz on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Genre, Movie, Soundtrack;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * imdbID;
@property (nonatomic, retain) NSString * rottenID;
@property (nonatomic, retain) NSString * plot;
@property (nonatomic, retain) NSData * poster;
@property (nonatomic, retain) NSString * imdbRating;
@property (nonatomic, retain) NSString * rottenAudienceRating;
@property (nonatomic, retain) NSString * rottenCriticRating;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSNumber * runningTimeInSec;
@property (nonatomic, retain) NSSet *genres;
@property (nonatomic, retain) NSSet *actors;
@property (nonatomic, retain) Soundtrack *soundtrack;
@property (nonatomic, retain) NSSet *similarMovies;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;

- (void)addActorsObject:(Actor *)value;
- (void)removeActorsObject:(Actor *)value;
- (void)addActors:(NSSet *)values;
- (void)removeActors:(NSSet *)values;

- (void)addSimilarMoviesObject:(Movie *)value;
- (void)removeSimilarMoviesObject:(Movie *)value;
- (void)addSimilarMovies:(NSSet *)values;
- (void)removeSimilarMovies:(NSSet *)values;

@end
