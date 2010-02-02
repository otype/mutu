//
//  Helpers.m
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 2/1/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import "Helpers.h"


@implementation Helpers

+(void)openURL:(NSString *)siteURL {
	NSURL *url = [NSURL URLWithString:siteURL];
	[[NSWorkspace sharedWorkspace] openURL:url];
	[url release];
}
@end
