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
	IBOutlet NSMenu *statusMenuOutlet;
	NSStatusItem *statusMenu;
	NSTask *sshTask;
	NSPipe *inputPipe;
	NSPipe *outputPipe;
	NSString *sshSocksPort;
	NSString *sshUser;
	NSString *sshServer;
}

@property (assign) IBOutlet		NSWindow	*window;
@property (assign)				NSTask		*sshTask;
@property (readwrite, assign)	NSString	*sshSocksPort;
@property (readwrite, assign)	NSString	*sshUser;
@property (readwrite, assign)	NSString	*sshServer;

-(IBAction)createTunnel:(id)sender;
-(IBAction)destroyTunnel:(id)sender;
-(IBAction)preferencesPanel:(id)sender;
-(IBAction)quitApplication:(id)sender;
@end
