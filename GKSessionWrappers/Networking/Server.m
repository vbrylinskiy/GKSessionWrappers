#import "Server.h"
#import "Connection.h"

@interface Server ()

@property (nonatomic, strong) GKSession* session;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, strong) NSMutableSet *connections;


@end


@implementation Server

@synthesize delegate;
@synthesize session;
@synthesize peerId;

-(NSString *)peerId {
    return self.session.peerID;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)initWithSessionId:(NSString *)sessionId;
{
    if (self=[super init]){
        _sessionId = sessionId;
        _connections = [NSMutableSet set];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stop)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(start)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    
    return self;
}


- (BOOL)start {
    if (![self createServer]) {
        return NO;
    }
    
    [self publishService];
    
    return YES;
}


- (void)stop {
    [self unpublishService];
    [self terminateServer];
}


- (BOOL)createServer {
    self.session = [[GKSession alloc] initWithSessionID:self.sessionId displayName:[NSString stringWithFormat:@"%@", [UIDevice currentDevice].name]  sessionMode:GKSessionModeServer];
    self.session.delegate = self;
    [self.session setDataReceiveHandler:self withContext:nil];
    return YES;
}


- (void)terminateServer {
    if (self.session != nil) {
        [session disconnectFromAllPeers];
        session.delegate = nil;
        self.session = nil;
        [self.connections removeAllObjects];
    }
}


- (void)publishService {
    self.session.available = YES;
}


- (void)unpublishService {
    self.session.available = NO;
}

- (void)broadcastNetworkPacket:(NSData*)packet {
    [self.connections makeObjectsPerformSelector:@selector(sendNetworkPacket:) withObject:packet];
}

- (Connection *)connectionForPeerId:(NSString *)_peerId {
    Connection *connection = [[self.connections filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"peerId == %@", _peerId]] anyObject];
    return connection;
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)_session peer:(NSString *)_peerID didChangeState:(GKPeerConnectionState)state
{
	switch (state) {
		case GKPeerStateConnected: {
            Connection *connection = [[Connection alloc] initWithSession:_session peerID:_peerID];
            [self.connections addObject:connection];
            
            if ([self.delegate respondsToSelector:@selector(handleNewConnection:)])
                [self.delegate handleNewConnection:connection];
            
			break;
        }
		case GKPeerStateDisconnected: {
            
            Connection *connection = [self connectionForPeerId:_peerID];
            
            if (connection) {
                [self.connections removeObject:connection];
                if ([self.delegate respondsToSelector:@selector(connectionTerminated:)]) {
                    [self.delegate connectionTerminated:connection];
                }
            }
            
			break;
        }
        default:
            break;
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)_peerID
{
	[self.session acceptConnectionFromPeer:_peerID error:nil];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)_peerID withError:(NSError *)error
{
    Connection *connection = [self connectionForPeerId:_peerID];
    
    if (connection) {
        [self.connections removeObject:connection];
        if ([self.delegate respondsToSelector:@selector(connectionTerminated:)]) {
            [self.delegate connectionTerminated:connection];
        }
    }
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(serverTerminated:reason:)])
        [self.delegate serverTerminated:self reason:@"Network connection failure"];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)_peer inSession: (GKSession *)session context:(void *)context
{
    Connection *connection = [self connectionForPeerId:_peer];

    if (connection) {
        if ([self.delegate respondsToSelector:@selector(connection:didReceiveData:)])
            [self.delegate connection:connection didReceiveData:data];
    }
}

@end
