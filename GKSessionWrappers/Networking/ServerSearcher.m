//
//  ServerSearcher.m
//  GKSessionWrappers
//
//  Created by Vladislav Brylinskiy on 12.11.13.
//  Copyright (c) 2013 Vladislav Brylinskiy. All rights reserved.
//

#import "ServerSearcher.h"
#import <GameKit/GKSession.h>
#import "Client.h"

@interface ServerSearcher () <GKSessionDelegate>

@property (nonatomic, strong) NSMutableArray *servers;
@property (nonatomic, strong) GKSession *session;
@property (nonatomic, copy) NSString *sessionId;

@end

@implementation ServerSearcher

- (id)initWithSessionId:(NSString *)sessionId {
    if (self = [super init]) {
        _servers = [NSMutableArray array];
        _sessionId = sessionId;
    }
    
    return self;
}

- (NSArray *)availableServers {
    return self.servers;
}

- (void)refresh {
    self.session.available = NO;
    self.session.available = YES;
}

- (void)startSearch {
    [self stopSearch];
    
    self.session = [[GKSession alloc] initWithSessionID:self.sessionId displayName:self.sessionId sessionMode:GKSessionModeClient];
    self.session.delegate = self;
    self.session.available = YES;
}

- (void)stopSearch {
    self.session.available = NO;
    self.session.delegate = nil;
    [self.session disconnectFromAllPeers];
    self.session = nil;
}

- (void)connectToServer:(NSString *)serverPeerId
{
    [self.session connectToPeer:serverPeerId withTimeout:5.];
}

#pragma mark - GKSessionDelegate

-(void)session:(GKSession *)session peer:(NSString *)_peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state) {
        case GKPeerStateAvailable:
        {
            if (![self.servers containsObject:_peerID]) {
                [self.servers addObject:_peerID];
                if ([self.delegate respondsToSelector:@selector(serverSearcherDidUpdateServerList:)])
                    [self.delegate serverSearcherDidUpdateServerList:self];
            }
            break;
        }
        case GKPeerStateUnavailable:
        {
            if ([self.servers containsObject:_peerID]) {
                [self.servers removeObject:_peerID];
                if ([self.delegate respondsToSelector:@selector(serverSearcherDidUpdateServerList:)])
                    [self.delegate serverSearcherDidUpdateServerList:self];

            }
            break;
        }
        case GKPeerStateConnected:
        {
            Connection *connection = [[Connection alloc] initWithSession:session peerID:_peerID];
            self.session.available = NO;
            
            if ([self.delegate respondsToSelector:@selector(serverSearcher:didCreateConnection:)])
                [self.delegate serverSearcher:self didCreateConnection:connection];
            
            break;
        }
        default:
            break;
    }
}

-(void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(serverSearcherConnectionDidFail:)]) {
        [self.delegate serverSearcherConnectionDidFail:self];
    }
}



@end
