//
//  MutuAppDelegate.h
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/22/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MutuAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusMenuItem;
}

@property (assign) NSTask *sshTask;
@property (assign) NSString *sshSocksPort;
@property (assign) NSString *sshUser;
@property (assign) NSString *sshServer;
@property (assign) NSString *tunnelScript;

@property (assign) IBOutlet NSWindow *window;

-(IBAction)createTunnel:(id)sender;
-(IBAction)destroyTunnel:(id)sender;
@end
