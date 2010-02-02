//
//  AppController.h
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/28/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class PreferenceController;


@interface AppController : NSObject {
	PreferenceController *preferenceController;
}

-(IBAction)showPreferencePanel:(id)sender;
-(void)openProjectSite:(id)sender;
-(void)openBugTrackingSite:(id)sender;
@end
