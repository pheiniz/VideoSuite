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

- (Actor *)createActorFrom:(NSDictionary *)actorDict{
    Actor* actor = (Actor *)[NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:[self managedObjectContext]];
    actor.actorID = [[actorDict objectForKey:@"id"] stringValue];
    actor.name = [actorDict objectForKey:@"name"];
    
    NSString *bio = [actorDict objectForKey:@"biography"];
    if (bio == (id)[NSNull null] || bio.length == 0 ){
        actor.biography = @"Not available";
    }else {
        //initial Wikipedia annotation is redundant
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\.| |\\n)*from Wikipedia, the free encyclopedia(\\.| |\\n)*" options:NSRegularExpressionCaseInsensitive error:nil];
        actor.biography = [regex stringByReplacingMatchesInString:bio options:0 range:NSMakeRange(0, [bio length]) withTemplate:@""];
    }
    
    NSString *birthday = [actorDict objectForKey:@"birthday"];
    if (birthday == (id)[NSNull null] || birthday.length == 0 ){
        actor.birthdate = @"-";
    }else {
        actor.birthdate = birthday;
    }

    NSString *birthplace = [actorDict objectForKey:@"place_of_birth"];
    if (birthplace == (id)[NSNull null] || birthplace.length == 0 ){
        actor.birthplace = @"-";
    }else {
        actor.birthplace = birthplace;
    }
    
    actor.character = [actorDict objectForKey:@"character"];
    
    NSLog(@"Downloading picture of %@", actor.name);
    NSString *actorImage = [NSString stringWithFormat:@"%@%@%@?%@", BASEPATH, PROFILESIZEMEDIUM, [actorDict objectForKey:@"profile_path"], TMDB_APIKEY];
    NSURL *posterUrl = [NSURL URLWithString: actorImage];
    actor.picture = UIImagePNGRepresentation([self posterWithURL:posterUrl]);

    return actor;
}

- (Movie *)createMovie:(NSString *) movieTitle withPath:(NSURL *) movieURL{
    Movie* movie = (Movie *)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:[self managedObjectContext]];
    Genre* genre = (Genre *)[NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:[self managedObjectContext]];
    
    [dataConnector setupMovie:movieTitle withPath:movieURL];
    
    movie.title = movieTitle;
    movie.imdbRating = dataConnector.stringForIMDBRating;
    movie.imdbID = dataConnector.rottenConnector.stringForIMDBID;
    movie.rottenCriticRating = dataConnector.stringForCriticsRating;
    movie.rottenAudienceRating = dataConnector.stringForAudienceRating;
    movie.rottenID = dataConnector.rottenConnector.movieID;
    movie.plot = [dataConnector.stringForDescription stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    movie.releaseDate = dataConnector.stringForReleaseYear;
    movie.runningTimeInSec = dataConnector.stringForRuntime;
    movie.filePath = movieURL.absoluteString;
    
    NSLog(@"Downloading poster for %@", movieTitle);
    NSURL *posterUrl = [NSURL URLWithString: [dataConnector stringForPoster]];
    movie.poster = UIImagePNGRepresentation([self posterWithURL:posterUrl]);
    
    genre.name = dataConnector.stringForGenre;
    [genre addMoviesObject:movie];
    [movie addGenresObject:genre];
    
    int order = 0;
    for (NSDictionary *actorJSON in dataConnector.cast) {
        Actor *actor = [self getActorWithJSONData:actorJSON];
        actor.order = [NSNumber numberWithInt:order];
        order ++;
        [actor addMoviesObject:movie];
        [movie addActorsObject:actor];
    }
    
    for (NSString *triviaItem in dataConnector.trivia) {
        Trivia* trivia = (Trivia *)[NSEntityDescription insertNewObjectForEntityForName:@"Trivia" inManagedObjectContext:[self managedObjectContext]];
        [trivia setTrivia:[triviaItem stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
        [trivia setMovie:movie];
        [movie addTriviasObject:trivia];
    }
    
    [self saveContext];
    
    return movie;
}

- (UIImage *)posterWithURL:(NSURL *) posterUrl{
    if (posterUrl == nil){
        return [UIImage imageNamed:@"silhouette250x300"];
    }else{
        return [UIImage imageWithData: [NSData dataWithContentsOfURL:posterUrl]];
    }
}


- (Actor *)getActorWithJSONData:(NSDictionary *) jsonData{
    
    NSNumber *actorID = [jsonData objectForKey:@"id"];
    
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
                              @"actorID LIKE %@",
                              [actorID stringValue]];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (!error){
        if ([fetchedObjects count] == 0) {
            result = [self createActorFrom:jsonData];
        }else {
            //fetch movie
            result = [fetchedObjects objectAtIndex:0];
        }
    }
    return result;
   
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
                              @"filePath LIKE %@",
                              movieURL.absoluteString];
    
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
}


/*
 Records sound from a certain position in movie and creates a fingerprint.
 Then sends finderprint to server asynchronously.
 
 TODO: Needs refactoring into another class

 */
- (void)recognizeSong: (NSURL *) songURL inInterval:(CMTimeRange) range withPauseTime:(NSNumber *) pauseTime{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSURL* destinationURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"temp_data"]];
    [[NSFileManager defaultManager] removeItemAtURL:destinationURL error:nil];

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:songURL options:nil];
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^ {
        
        NSArray* assets = [asset tracksWithMediaType:AVMediaTypeAudio];
        AVAssetTrack* audioTrack = [assets objectAtIndex:0];
        AVMutableComposition* audioComposition = [AVMutableComposition composition];
        AVMutableCompositionTrack* audioCompositionTrack = [audioComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioCompositionTrack insertTimeRange:range ofTrack:audioTrack atTime:kCMTimeZero error:nil];
        
        
        AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:audioComposition presetName:AVAssetExportPresetPassthrough];
        exportSession.outputURL = destinationURL;
        exportSession.outputFileType = AVFileTypeAppleM4A;
        
        [exportSession exportAsynchronouslyWithCompletionHandler: ^(void) {
            
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                NSString *outPath = [documentsDirectory stringByAppendingPathComponent:@"temp_data"];
                NSLog(@"done now. %@", outPath);
                //[statusLine setText:@"analysing..."];
                char * code = GetPCMFromFile((char*) [outPath  cStringUsingEncoding:NSASCIIStringEncoding]);
                
                NSString *songTitle = [dataConnector recognizeSongFromCode:code];
                NSLog(@"song = %@", songTitle);
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:songTitle, @"title", pauseTime, @"time", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName: @"MusicTitleFoundNotification" object:nil userInfo:userInfo];
                
            }
        }];
    }];

}

- (NSString *)recognizeFace:(UIImage *)image
{
    return [dataConnector recognizeFace:image];
}

@end
