//
// Copyright (c) 2010, Otype (Hans-Gunther Schmidt)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name of the Joseph A. Roback nor the names of its contributors
//   may be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
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
	NSString *withProtocol;
	if (![[siteURL substringToIndex:7] isEqualToString:@"http://"]) {
		withProtocol = [@"http://" stringByAppendingString:siteURL];
	} else {
		withProtocol = siteURL;
	}
			
	NSURL *url = [NSURL URLWithString:withProtocol];
	if ([[NSWorkspace sharedWorkspace] openURL:url]) {
		NSLog(@"Calling URL %@", withProtocol);
	} else {
		NSLog(@"[ERROR] Incorrect URL layout! URL = %@", withProtocol);
	}
	
	// GC
	siteURL = nil;
	withProtocol = nil;
	url = nil;
}

@end
