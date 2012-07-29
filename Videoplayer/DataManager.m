//
//  DataManager.m
//  Videoplayer
//
//  Created by heiniz on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize dataConnector;

static DataManager *sharedInstance = nil;


// Get the shared instance and create it if necessary.
+ (DataManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        dataConnector = [DataConnector sharedInstance];
    }
    
    return self;
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

#pragma mark -
#pragma mark Database

- (void) deleteObject: (NSManagedObject *) object{
    [[self managedObjectContext] deleteObject:object];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    
    if (__managedObjectContext != nil)
    {
        if ([__managedObjectContext hasChanges] && ![__managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
            NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
            if(detailedErrors != nil && [detailedErrors count] > 0) {
                for(NSError* detailedError in detailedErrors) {
                    NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                }
            }
            else {
                NSLog(@"  %@", [error userInfo]);
            }
            abort();
        } 
    }
}

- (void) deleteDatabase{
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Player.sqlite"];
    
    //in case of errors in persistance store use this to delete current store
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    //mom because no versioning. in case of arror try out momd
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Player" withExtension:@"momd"]; 
    
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Player.sqlite"];
    
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Object creation

- (Actor *)createActorWithName:(NSString *) name andID:(NSString *) rottenID{
    Actor* actor = (Actor *)[NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:[self managedObjectContext]];
    actor.rottenID = rottenID;
    actor.name = name;
    
    return actor;
}

- (Movie *)createMovie:(NSString *) movieTitle withPath:(NSURL *) movieURL{
    Movie* movie = (Movie *)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:[self managedObjectContext]];
    Genre* genre = (Genre *)[NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:[self managedObjectContext]];
    
    [dataConnector setupMovie:movieTitle withPath:movieURL];
    
    movie.title = movieTitle;
    movie.imdbRating = dataConnector.stringForIMDBRating;
    movie.imdbID = dataConnector.imdbConnector.imdbMovieID;
    movie.rottenCriticRating = dataConnector.stringForCriticsRating;
    movie.rottenAudienceRating = dataConnector.stringForAudienceRating;
    movie.rottenID = dataConnector.rottenConnector.movieID;
    movie.plot = dataConnector.stringForDescription;
    movie.releaseDate = dataConnector.stringForReleaseYear;
    movie.runningTimeInSec = (NSNumber *)dataConnector.stringForRuntime;
    movie.filePath = movieURL.absoluteString;
    
    NSURL *posterUrl = [NSURL URLWithString: [dataConnector stringForPoster]];
    movie.poster = UIImagePNGRepresentation([self posterWithURL:posterUrl]);
    
    genre.name = dataConnector.stringForGenre;
    [genre addMoviesObject:movie];
    [movie addGenresObject:genre];
    
    for (NSDictionary *actorJSON in dataConnector.cast) {
        Actor *actor = [self getActorWithJSONData:actorJSON];
        [actor addMoviesObject:movie];
        [movie addActorsObject:actor];
    }
    
    [self saveContext];
    
    return movie;
}

- (UIImage *)posterWithURL:(NSURL *) posterUrl{
    return [UIImage imageWithData: [NSData dataWithContentsOfURL:posterUrl]];
}


- (Actor *)getActorWithJSONData:(NSDictionary *) jsonData{
    
    //SBJsonParser *parser = [[SBJsonParser alloc] init];
//    NSMutableDictionary *json = [parser objectWithString:jsonData error:nil];
    NSString *rottenID = [jsonData objectForKey:@"id"];
    NSString *name = [jsonData objectForKey:@"name"];
    
    Actor* result = nil;
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Actor" inManagedObjectContext:[[DataManager sharedInstance] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"rottenID LIKE %@",
                              rottenID];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (!error){
        if ([fetchedObjects count] == 0) {
            result = [self createActorWithName:name andID:rottenID];
        }else {
            //fetch movie
            result = [fetchedObjects objectAtIndex:0];
        }
    }
    return result;
    //[self performSelectorInBackground:@selector(updateProgressView:) withObject:[NSString stringWithFormat:@"%f",percent]];
    
}

- (Movie *)getMovie:(NSString *) movieTitle withPath:(NSURL *) movieURL{
    
    Movie* result = nil;
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:[[DataManager sharedInstance] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"title LIKE %@",
                              movieTitle];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (!error){
        if ([fetchedObjects count] == 0) {
            result = [self createMovie:movieTitle withPath:movieURL];
        }else {
            //fetch movie
            result = [fetchedObjects objectAtIndex:0];
        }
    }
    return result;
    //[self performSelectorInBackground:@selector(updateProgressView:) withObject:[NSString stringWithFormat:@"%f",percent]];
}

@end
