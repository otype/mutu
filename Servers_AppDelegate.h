//
//  ServerManager_AppDelegate.h
//  ServerManager
//
//  Created by Hans-Gunther Schmidt on 1/29/10.
//  Copyright Otype 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Servers_AppDelegate : NSObject 
{    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;

@end
