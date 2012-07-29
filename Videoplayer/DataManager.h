//
//  DataManager.h
//  Videoplayer
//
//  Created by heiniz on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataConnector.h"
#import "Actor.h"
#import "Song.h"
#import "Movie.h"
#import "Soundtrack.h"
#import "Genre.h"

@interface DataManager : NSObject <NSFetchedResultsControllerDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedWaypointsController;

@property (retain) DataConnector *dataConnector;

+ (id)sharedInstance;

- (void)saveContext;
- (void) deleteDatabase;

- (Movie *)createMovie:(NSString *) movieTitle withPath:(NSURL *) movieURL;
- (Actor *)createActorWithName:(NSString *) name andID:(NSString *) rottenID;
- (Movie *)getMovie:(NSString *) movieTitle withPath:(NSURL *) movieURL;
- (Actor *)getActorWithJSONData:(NSDictionary *) jsonData;
- (UIImage *)posterWithURL:(NSURL *) posterurl;

@end
