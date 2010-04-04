//
// Copyright (c) 2009, Joseph A. Roback
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
//  SSHTunnelHelper.m
//  SSHTunnel
//
//  Created by Joseph Roback on 12/11/09.
//  Copyright 2009 Joseph A. Roback. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NDEBUG
extern NSUInteger STDebugLevel;

#define STDebugOn(x) (STDebugLevel & (x))
#define STDebugThis(x) do {                                            \
	if (STDebugOn(x)) {                                                \
		NSLog(@"[%@:%04d][%@] .",                                      \
			NSStringFromClass([self class]), __LINE__,                 \
			NSStringFromSelector(_cmd));                               \
	}                                                                  \
} while (0)
#define STDebugLog(x, fmt, ...) do {                                   \
	if (STDebugOn(x)) {                                                \
		NSLog([@"[%@:%04d][%@] " stringByAppendingString:fmt],         \
			NSStringFromClass([self class]), __LINE__,                 \
			NSStringFromSelector(_cmd),                                \
			## __VA_ARGS__);                                           \
	}                                                                  \
} while (0)
#else
#define STDebugOn(x) ((void) 0)
#define STDebugThis(x) ((void) 0)
#define STDebugLog(x, fmt, ...) ((void) 0)
#endif

#define ST_D_NONE            0x0000000000000000
#define ST_D_THIS            0x0000000000000001
#define ST_D_INIT            (ST_D_THIS << 1)
#define ST_D_DEALLOC         (ST_D_THIS << 2)
#define ST_D_LAUNCH          (ST_D_THIS << 3)
#define ST_D_TERMINATE       (ST_D_THIS << 4)
#define ST_D__TERMINATE      (ST_D_THIS << 5)
#define ST_D_SSHDIDTERMINATE (ST_D_THIS << 6)
#define ST_D_SSHSTDERR       (ST_D_THIS << 7)
#define ST_D_CLEANUPPIPE     (ST_D_THIS << 8)
#define ST_D_PROCESSOUTPUT   (ST_D_THIS << 9)
#define ST_D_PIPETHREAD      (ST_D_THIS << 10)
#define ST_D_ALL             0xffffffffffffffff
