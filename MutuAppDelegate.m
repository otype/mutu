//
//  MutuAppDelegate.m
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/22/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import "MutuAppDelegate.h"
#import "PreChecks.h"

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
	
    if (status == 0) {
		/* THIS PART IS MOST LIKELY NEVER BEING CALLED */
		NSLog(@"Task response: %@", [result componentsSeparatedByString:@"\n"]);
	} else {
		NSLog(@"Tunnel task terminated");
		NSArray *terminalResponses;
		terminalResponses = [result componentsSeparatedByString:@"\n"];
		for(NSDictionary *responseLine in terminalResponses) {
			if ([(NSString *)responseLine length] != 0) {				
				NSLog(@"[TERMRESP] \"%@\"", responseLine);
				[self killTask];
//				[self somethingWentWrong];
			}
		}
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
	[self killTask];
}

-(void)killTask {
	if ([sshTask isRunning]) {
		NSLog(@"Destroying tunnel with PID = \"%d\"", [sshTask processIdentifier]);
		[sshTask interrupt];
		[sshTask waitUntilExit];
		NSLog(@"Tunnel closed!");
	} else {
		NSLog(@"No tunnels exist!");
	}
	
	[self switchMenuItemTitle:TRUE stopItem:FALSE];
	
	/* GC */
	sshTask = nil;
	inputPipe = nil;
	outputPipe = nil;	
}

-(IBAction)preferencesPanel:(id)sender {
	NSLog(@"Preferences Panel");
}

-(void)switchMenuItemTitle:(BOOL)startItem stopItem:(BOOL)stopItemValue {
	[startTunnelMenuItem setEnabled:startItem];
	[stopTunnelMenuItem setEnabled:stopItemValue];	
}

//-(void)somethingWentWrong {
//	NSLog(@"[ERROR] Uh-oh! Something went wrong!");
//	NSRunAlertPanel(@"Tunnel is down!", @"Please check what went wrong!", @"OK", nil, nil);
//
//}

@end
