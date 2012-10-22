//
//  Trivia.h
//  Videoplayer
//
//  Created by Paul Heiniz on 29.09.12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Trivia : NSManagedObject

@property (nonatomic, retain) NSString * trivia;
@property (nonatomic, retain) NSNumber * frame;
@property (nonatomic, retain) Movie *movie;

@end
