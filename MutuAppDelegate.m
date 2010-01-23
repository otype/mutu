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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

-(void)awakeFromNib {
	statusMenuItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusMenuItem setMenu:statusMenu];
	[statusMenuItem setTitle:@"Mutu"];
	[statusMenuItem setHighlightMode:YES];
}
@end
