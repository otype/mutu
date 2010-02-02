//
//  AppController.m
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/28/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import "Constants.h"
#import "AppController.h"
#import "Helpers.h"
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


/**
	OPEN URLS
	Open various URLs relevant to the project
 */
-(void)openProjectSite:(id)sender {
	NSLog(@"Launching %@ in browser", ProjectSiteURL);
	[Helpers openURL:ProjectSiteURL];
}

-(void)openBugTrackingSite:(id)sender {
	NSLog(@"Launching %@ in browser", ProjectBugTrackingSiteURL);
	[Helpers openURL:ProjectBugTrackingSiteURL];
}
@end
