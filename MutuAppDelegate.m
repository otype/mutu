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

-(void)awakeFromNib {
	statusMenuItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusMenuItem setMenu:statusMenu];
	[statusMenuItem setTitle:@"Mutu"];
	//	[statusMenuItem setImage:(NSImage *)image];
	[statusMenuItem setHighlightMode:YES];
}

-(id)init {
	[super init];
	NSLog(@"Initialized!");
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	sshSocksPort = @"7777";
//	sshUser = @"mavjones";
//	sshServer = @"bruja.cs.tu-berlin.de";
	sshUser = @"hgschmidt";
	sshServer = @"localhost";
	tunnelScript = @"/tmp/tunnel.sh";	
}


-(IBAction)createTunnel:(id)sender {	
	sshTask = [[NSTask alloc] init];
    [sshTask setLaunchPath: tunnelScript];
	
    NSArray *arguments;
	arguments = [NSArray arrayWithObjects: sshSocksPort, sshUser, sshServer, nil];
	
	NSLog([arguments componentsJoinedByString:@" "]);
	NSLog(@"SOCKS PORT = %@", sshSocksPort);
	NSLog(@"SSH USER = %@", sshUser);
	NSLog(@"SSH SERVER = %@", sshServer);
	
    [sshTask setArguments: arguments];
	[sshTask launch];

	NSLog(@"Tunnel established!");
	NSLog(@"Tunnel CWD = %@", [sshTask currentDirectoryPath]);	
}

-(IBAction)destroyTunnel:(id)sender {
	NSLog(@"Attempting to close tunnel");

	[sshTask terminate];
	sshTask = nil;
	
	NSLog(@"Tunnel closed!");
}
@end