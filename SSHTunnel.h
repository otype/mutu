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
//  SSHTunnel.h
//  SSHTunnel
//
//  Created by Joseph Roback on 12/11/09.
//  Copyright 2009 Joseph A. Roback. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
	SSHTunnelTerminationReasonExit = 1,
	SSHTunnelTerminationReasonPermissionDenied = 2,
	SSHTunnelTerminationReasonHostKeyVerificationFailed = 3,
	SSHTunnelTerminationReasonResolveHostnameFailed = 4,
	SSHTunnelTerminationReasonConnectTimeout = 5,
	SSHTunnelTerminationReasonConnectionRefused = 6,
	SSHTunnelTerminationReasonLocalBindAddressInUse = 7,
	SSHTunnelTerminationReasonRemoteBindAddressInUse = 8
};

typedef NSInteger SSHTunnelTerminationReason;

enum {
	SSHTunnelX11ForwardingNone = 1,
	SSHTunnelX11ForwardingUntrusted = 2,
	SSHTunnelX11ForwardingTrusted = 3
};

typedef NSInteger SSHTunnelX11Forwarding;

/*!
 @abstract SSH Tunnels
 @discussion An SSHTunnel instance is ...
 @throws NSInvalidArgumentException
 @updated 2009-12-16
*/

@interface SSHTunnel : NSObject {
@protected
	NSString *_sshLaunchPath;
	
	NSString *_hostname;
	NSUInteger _port;
	
	NSString *_username;
	NSString *_password;
	
	BOOL _allocatesPseudoTTY;
	BOOL _allowsPasswordAuthentication;	
	BOOL _allowsPublicKeyAuthentication;
	BOOL _allowRemoteHostsToUseForwardedPorts;
	NSUInteger _connectTimeout;
	BOOL _forceIPv4;
	BOOL _forceIPv6;
	BOOL _forceProtocol1;
	BOOL _forceProtocol2;
	BOOL _gatewayPorts;
	NSString *_identityFile;
	SSHTunnelX11Forwarding _X11Forwarding;
	
	NSMutableArray *_localForwards;
	NSMutableArray *_remoteForwards;
	NSMutableArray *_dynamicForwards;
	
	NSFileHandle *_namedPipeHandle;
	NSString *_namedPipe;
	NSTask *_sshTask;
	NSFileHandle *_sshErrHandle;
	BOOL _launched;
	BOOL _connected;
	SSHTunnelTerminationReason _terminationReason;
}

@property (readwrite,retain) NSString *sshLaunchPath;

@property (readwrite,retain) NSString *hostname;
@property (readwrite,assign) NSUInteger port;

@property (readwrite,retain) NSString *username;
@property (readwrite,retain) NSString *password;

@property (readwrite,assign) BOOL allocatesPseudoTTY;
@property (readwrite,assign) BOOL allowsPasswordAuthentication;
@property (readwrite,assign) BOOL allowsPublicKeyAuthentication;
@property (readwrite,assign) BOOL allowRemoteHostsToUseForwardedPorts;
@property (readwrite,assign) NSUInteger connectTimeout;
@property (readwrite,assign) BOOL forceIPv4;
@property (readwrite,assign) BOOL forceIPv6;
@property (readwrite,assign) BOOL forceProtocol1;
@property (readwrite,assign) BOOL forceProtocol2;
@property (readwrite,assign) BOOL  gatewayPorts;
@property (readwrite,retain) NSString *identityFile;
@property (readwrite,assign) SSHTunnelX11Forwarding X11Forwarding;

@property (readonly) NSArray *localForwards;
@property (readonly) NSArray *remoteForwards;
@property (readonly) NSArray *dynamicForwards;

@property (readonly,assign,getter=isConnected) BOOL connected;
@property (readonly,assign) SSHTunnelTerminationReason terminationReason;

+ (SSHTunnel *)sshTunnelWithHostname:(NSString *)hostname
								port:(NSUInteger)port
							username:(NSString *)username
							password:(NSString *)password;

- (id)init;

- (id)initWithHostname:(NSString *)hostname
				  port:(NSUInteger)port
			  username:(NSString *)username
			  password:(NSString *)password;

- (void)addLocalForwardWithBindAddress:(NSString *)bindAddress
							  bindPort:(NSUInteger)bindPort
								  host:(NSString *)host
							  hostPort:(NSUInteger)hostPort;

- (void)addRemoteForwardWithBindAddress:(NSString *)bindAddress
							   bindPort:(NSUInteger)bindPort
								   host:(NSString *)host
							   hostPort:(NSUInteger)hostPort;

- (void)addDynamicForwardWithBindAddress:(NSString *)bindAddress
								bindPort:(NSUInteger)bindPort;

- (void)launch;
- (void)terminate;
- (void)waitUntilExit;

- (BOOL)isRunning;
- (int)sshProcessIdentifier;

@end

#define SSHTUNNEL_EXTERN extern
#define kSSHTunnelNamedPipe @"SSHTUNNEL_NAMEDPIPE"

SSHTUNNEL_EXTERN NSString * const SSHTunnelDidConnectNotification;
SSHTUNNEL_EXTERN NSString * const SSHTunnelDidTerminateNotification;

SSHTUNNEL_EXTERN NSString * const SSHTunnelNotificationForwardTunnelsItem;
SSHTUNNEL_EXTERN NSString * const SSHTunnelNotificationReverseTunnelsItem;

SSHTUNNEL_EXTERN NSString * const kSSHTunnelForwardBindAddress;
SSHTUNNEL_EXTERN NSString * const kSSHTunnelForwardBindPort;
SSHTUNNEL_EXTERN NSString * const kSSHTunnelForwardHost;
SSHTUNNEL_EXTERN NSString * const kSSHTunnelForwardHostPort;
