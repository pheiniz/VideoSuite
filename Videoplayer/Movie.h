//
//  Movie.h
//  Videoplayer
//
//  Created by Paul Heiniz on 29.09.12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Genre, Movie, Soundtrack, Trivia;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * imdbID;
@property (nonatomic, retain) NSString * imdbRating;
@property (nonatomic, retain) NSString * plot;
@property (nonatomic, retain) NSData * poster;
@property (nonatomic, retain) NSString * releaseDate;
@property (nonatomic, retain) NSString * rottenAudienceRating;
@property (nonatomic, retain) NSString * rottenCriticRating;
@property (nonatomic, retain) NSString * rottenID;
@property (nonatomic, retain) NSNumber * runningTimeInSec;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *actors;
@property (nonatomic, retain) NSSet *genres;
@property (nonatomic, retain) NSSet *similarMovies;
@property (nonatomic, retain) Soundtrack *soundtrack;
@property (nonatomic, retain) NSSet *trivias;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addActorsObject:(Actor *)value;
- (void)removeActorsObject:(Actor *)value;
- (void)addActors:(NSSet *)values;
- (void)removeActors:(NSSet *)values;

- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;

- (void)addSimilarMoviesObject:(Movie *)value;
- (void)removeSimilarMoviesObject:(Movie *)value;
- (void)addSimilarMovies:(NSSet *)values;
- (void)removeSimilarMovies:(NSSet *)values;

- (void)addTriviasObject:(Trivia *)value;
- (void)removeTriviasObject:(Trivia *)value;
- (void)addTrivias:(NSSet *)values;
- (void)removeTrivias:(NSSet *)values;

@end
