//
//  Trivia.h
//  Videoplayer
//
//  Created by Paul Heiniz on 24/07/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Trivia : NSManagedObject

@property (nonatomic, retain) NSNumber * frame;
@property (nonatomic, retain) NSString * trivia;
@property (nonatomic, retain) Movie *movie;

@end
