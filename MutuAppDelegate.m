//
// Copyright (c) 2010, Otype (Hans-Gunther Schmidt)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name of the Joseph A. Roback nor the names of its contributors
//   may be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//  MutuAppDelegate.m
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/22/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import "MutuAppDelegate.h"
#import "Servers_AppDelegate.h"

@implementation MutuAppDelegate

@synthesize window;

@synthesize sshTask;
@synthesize sshSocksPort;
@synthesize sshUser;
@synthesize sshServer;


-(void)awakeFromNib {
	statusMenuItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	
	NSImage *statusImage = [NSImage imageNamed:@"Emerald.gif"];
	[statusMenuItem setImage:statusImage];
	[statusMenuItem setHighlightMode:YES];	
	[statusMenuItem setMenu:statusMenu];
//	[statusMenuItem setTitle:NSLocalizedString(@"Mutu", @"Mutu menu item text")];	
	[self addHostnamesToStatusbarMenu];
}


-(id)init {
    self = [super init];	

	NSLog(@"Initializing: [TaskObserver]");
	NSNotificationCenter *notificationCenter;
	notificationCenter = [NSNotificationCenter defaultCenter];	
	[notificationCenter removeObserver:self];
    [notificationCenter addObserver:self
						   selector:@selector(checkATaskStatus:)
							   name:NSTaskDidTerminateNotification
							 object:sshTask];	
	
    return self;
}


- (void)checkATaskStatus:(NSNotification *)aNotification {
    int status = [[aNotification object] terminationStatus];
	NSData *data = [[outputPipe fileHandleForReading] readDataToEndOfFile];	
	NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];	
	
    if (status != 0) {
		NSLog(@"Tunnel task terminated");
		NSArray *terminalResponses;
		terminalResponses = [result componentsSeparatedByString:@"\n"];
		for(NSDictionary *responseLine in terminalResponses) {
			if ([(NSString *)responseLine length] != 0) {				
				NSLog(@"[TERMRESP] \"%@\"", responseLine);
				[self killSSHTask];
			}
		}		
	} else {
		/* THIS PART IS MOST LIKELY NEVER BEING CALLED */
		NSLog(@"Task response: %@", [result componentsSeparatedByString:@"\n"]);
	}        
	
	/* GC */
	data = nil;
	result = nil;	
}


-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSLog(@"Initializing: [Connection Details]");

	sshSocksPort = @"7777";
	sshUser = @"mavjones";
	sshServer = @"bruja.cs.tu-berlin.de";
//	sshUser = @"hgschmidt";
//	sshServer = @"localhost";

	NSLog(@"Initialization finished");
	[self switchMenuItemTitle:TRUE stopItem:FALSE];
}


/*
 * Create a tunnel with given login credentials and server information
 * on a given SOCKS Port.
 */
-(IBAction)createTunnel:(id)sender {
	if (sshTask) {
		NSLog(@"Found an established tunnel with PID = \"%d\"! Skipping!", [sshTask processIdentifier]);
		return;
	}
	
	sshTask = [[NSTask alloc] init];
	inputPipe = [[NSPipe alloc] init];
	outputPipe = [[NSPipe alloc] init];
	
	[sshTask setStandardInput:inputPipe];
	[sshTask setStandardOutput:outputPipe];
	[sshTask setStandardError:outputPipe];
	
	[sshTask setLaunchPath:@"/usr/bin/ssh"];
	[sshTask setArguments:[NSArray arrayWithObjects: @"-D", sshSocksPort, @"-l", sshUser, @"-N", sshServer, nil]];

	NSLog(@"Establishing tunnel ...");
	NSLog(@"-> SOCKS PORT = \"%@\"", sshSocksPort);
	NSLog(@"-> SSH SERVER = \"%@\"", sshServer);
	NSLog(@"-> SSH USER = \"%@\"", sshUser);
	[sshTask launch];
	
	NSLog(@"SSH Tunnel PID = \"%d\"", [sshTask processIdentifier]);

	[self switchMenuItemTitle:FALSE stopItem:TRUE];
}


-(IBAction)destroyTunnel:(id)sender {
	[self killSSHTask];
}

-(void)killSSHTask {
	if ([sshTask isRunning]) {
		NSLog(@"Destroying tunnel with PID = \"%d\"", [sshTask processIdentifier]);
		[sshTask interrupt];
		[sshTask waitUntilExit];
		NSLog(@"Tunnel closed!");
	} else {
		// Be quiet!
	}
	
	[self switchMenuItemTitle:TRUE stopItem:FALSE];
	
	/* GC */
	sshTask = nil;
	inputPipe = nil;
	outputPipe = nil;	
}

-(void)switchMenuItemTitle:(BOOL)startItem stopItem:(BOOL)stopItemValue {
	[startTunnelMenuItem setEnabled:startItem];
	[stopTunnelMenuItem setEnabled:stopItemValue];	
}



-(void)addHostnamesToStatusbarMenu {
	if (!serversAppDelegate) {
		NSLog(@"Initializing: [ServersAppDelegate]");
		serversAppDelegate = [[Servers_AppDelegate alloc] init];
	}
	
	NSManagedObjectContext *moc = [serversAppDelegate managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Server" inManagedObjectContext:moc];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	// Set result type to Dictionaries
	[request setResultType:NSDictionaryResultType];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hostname" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	
	NSError *error;
	NSArray *objects = [moc executeFetchRequest:request error:&error];
	if (objects == nil) {
		// Handle the error.
		NSLog(@"[ERROR] Empty database!");
	} else {
		NSMenu *tunnelMenu = [[NSMenu alloc] initWithTitle:@""];
		for (int i = 0; i < [objects count]; i++) {
			NSLog(@"HOSTS = %@", [[objects objectAtIndex:i] valueForKey:@"hostname"]);			
			NSMenuItem *currentItem = [[NSMenuItem alloc] initWithTitle:[[objects objectAtIndex:i] valueForKey:@"hostname"] 
																 action:@selector(startTunnelWithGivenHostname:) 
														  keyEquivalent:@""];
			
			[tunnelMenu addItem:currentItem];	
		}
		[tunnelMenu setSubmenu:tunnelMenu forItem:startTunnelSubMenuItem];
	}			
}

-(void)startTunnelWithGivenHostname:(id)sender {
	NSLog(@"Starting tunnel with %@!", sender);
	NSLog(@"MENU ITEM TITLE = %@", [(NSMenuItem *)sender title]);
}

@end
