//
//  PreferenceController.h
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/28/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferenceController : NSWindowController {
	IBOutlet NSButton *okButton;
	IBOutlet NSButton *cancelButton;
	IBOutlet NSTextField *usernameField;
	IBOutlet NSTextField *passwordField;
	IBOutlet NSTextField *servernameField;
	IBOutlet NSTextField *socksPortField;
}

-(IBAction)changeSSHCredentials:(id)sender;
-(IBAction)cancelSettingNewLoginData:(id)sender;

@end
