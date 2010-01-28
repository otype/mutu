//
//  AppController.m
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/28/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

-(IBAction)showPreferencePanel:(id)sender {	
	// Is PreferenceController nil?
	if (!preferenceController) {
		NSLog(@"Initializing: [PreferenceController]");
		preferenceController = [[PreferenceController alloc] init];
	}
	
	NSLog(@"showing %@", preferenceController);
	[preferenceController showWindow:self];
}

@end
