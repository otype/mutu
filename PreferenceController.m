//
//  PreferenceController.m
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/28/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import "PreferenceController.h"
#import "MutuAppDelegate.h"

@implementation PreferenceController

-(id)init {
	if (![super initWithWindowNibName:@"Preferences"])
		  return nil;
	return self;
}

-(void)windowDidLoad {
	NSLog(@"Initializing: [PreferencePanel]");
}

-(IBAction)changeSSHCredentials:(id)sender {	
	if (([[usernameField stringValue] length] == 0) ||
		([[passwordField stringValue] length] == 0) ||
		([[servernameField stringValue] length] == 0)) {
		
		NSRunAlertPanel(@"Empty fields", @"Please provide values for all fields!", @"OK", nil, nil);
		//NSLog(@"Alert choice = \"%d\"", choice);		
		NSLog(@"[ERROR] Empty fields");
	} else {
		NSLog(@"Setting credentials:");
		NSLog(@"-> USERNAME = \"%@\"", [usernameField stringValue]);
		NSLog(@"-> PASSWORD = \"%@\"", [passwordField stringValue]);
		NSLog(@"-> SERVERNAME = \"%@\"", [servernameField stringValue]);
		
		[self close];		
	}

}

-(IBAction)cancelSettingNewLoginData:(id)sender {
	NSLog(@"Cancelling");
	[self close];
}

@end
