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
//	statusMenuItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
//	[statusMenuItem setMenu:statusMenu];
//	[statusMenuItem setTitle:@"Mutu"];
//	//	[statusMenuItem setImage:(NSImage *)image];
//	[statusMenuItem setHighlightMode:YES];
	
	statusMenu = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusMenu setMenu:statusMenuOutlet];
	[statusMenu setTitle:@"Mutu"];
	//	[statusMenu setImage:(NSImage *)image];
	[statusMenu setHighlightMode:YES];
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
			if ([(NSString *)responseLine length] != 0)
				NSLog(@"[TERMRESP] \"%@\"", responseLine);
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
//	tunnelScript = @"/tmp/tunnel.sh";	
	NSLog(@"Initialization finished");		
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
}


-(IBAction)destroyTunnel:(id)sender {
	if ([sshTask isRunning]) {
		NSLog(@"Destroying tunnel with PID = \"%d\"", [sshTask processIdentifier]);
		[sshTask interrupt];
		[sshTask waitUntilExit];
		NSLog(@"Tunnel closed!");				
	} else {
		NSLog(@"No tunnel established at the moment!");
	}
	
	/* GC */
	sshTask = nil;
	inputPipe = nil;
	outputPipe = nil;
}

-(IBAction)preferencesPanel:(id)sender {
	NSLog(@"Preferences Panel");
}

-(IBAction)quitApplication:(id)sender {
	NSLog(@"Quitting application! Bye bye!");
	[NSApp terminate:self];
}

@end