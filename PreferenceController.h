//
//  PreferenceController.h
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/28/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferenceController : NSWindowController {
	
	/* Create a single server credential record */
	IBOutlet NSButton *saveButton;
	IBOutlet NSButton *cancelButton;
	IBOutlet NSTextField *usernameField;
	IBOutlet NSTextField *passwordField;
	IBOutlet NSTextField *servernameField;
	IBOutlet NSTextField *socksPortField;
	
	/* List of servers */
	IBOutlet NSTableView *serverTable;
	
}

-(IBAction)changeSSHCredentials:(id)sender;
-(IBAction)cancelSettingNewLoginData:(id)sender;

@end
