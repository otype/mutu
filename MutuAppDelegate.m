//
//  MutuAppDelegate.m
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/22/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import "MutuAppDelegate.h"

@implementation MutuAppDelegate

@synthesize window;
@synthesize sshTask;
@synthesize sshSocksPort;
@synthesize sshUser;
@synthesize sshServer;
@synthesize tunnelScript;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	sshTask = [[NSTask alloc] init];
	sshSocksPort = @"7777";
	sshUser = @"mavjones";
	sshServer = @"bruja.cs.tu-berlin.de";
	tunnelScript = @"/tmp/tunnel.sh";	
}

-(void)awakeFromNib {
	statusMenuItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusMenuItem setMenu:statusMenu];
	[statusMenuItem setTitle:@"Mutu"];
	[statusMenuItem setHighlightMode:YES];
}

-(IBAction)createTunnel:(id)sender {	
    [sshTask setLaunchPath: tunnelScript];
	
    NSArray *arguments;
	arguments = [NSArray arrayWithObjects: sshSocksPort, sshUser, sshServer, nil];
	
	NSLog([arguments componentsJoinedByString:@" "]);
	NSLog(@"SOCKS PORT = %@", sshSocksPort);
	NSLog(@"SSH USER = %@", sshUser);
	NSLog(@"SSH SERVER = %@", sshServer);
	
    [sshTask setArguments: arguments];
	[sshTask launch];
	NSLog(@"Tunnel established");
}

-(IBAction)destroyTunnel:(id)sender {
	NSLog(@"Attempting to close tunnel");
	[sshTask interrupt];
	NSLog(@"debug");

//	while ([sshTask isRunning]) {
//		NSLog(@"Still waiting");
//		sleep(1);
//		NSLog(@"Still waiting");
//	}
//
//	NSLog(@"Task is still running? %d", [sshTask isRunning]);

//	
//	if (![sshTask isRunning]) {
//		int status = [sshTask terminationStatus];
//		if (status == 0)
//			NSLog(@"Task succeeded.");
//		else
//			NSLog(@"Task failed.");
//	}
}
@end