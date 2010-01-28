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
	
	NSStatusItem *statusMenuItem;
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSMenuItem *startTunnelMenuItem;
	IBOutlet NSMenuItem *stopTunnelMenuItem;
	
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
-(void)killTask;
-(void)switchMenuItemTitle:(BOOL)startItem stopItem:(BOOL)stopItemValue;
//-(void)somethingWentWrong;

@end
