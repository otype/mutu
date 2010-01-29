//
//  main.m
//  Mutu
//
//  Created by Hans-Gunther Schmidt on 1/22/10.
//  Copyright 2010 Otype. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
	NSLog(@"Using GC = %@", [NSGarbageCollector defaultCollector]);
    return NSApplicationMain(argc,  (const char **) argv);
}
