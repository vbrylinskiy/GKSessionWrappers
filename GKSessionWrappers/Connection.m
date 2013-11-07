#import "Connection.h"

@interface Connection ()

@property (nonatomic, strong) GKSession *session;
@property (nonatomic, copy) NSString *peerId;

@end

@implementation Connection

@synthesize peerId = _peerId;

- (id)initWithSession:(GKSession *)session peerID:(NSString *)peerID
{
    if (self = [super init]) {
        _session = session;
        _session.delegate = self;
        _peerId = peerID;
        [_session setDataReceiveHandler:self withContext:nil];
    }
    return self;
}

- (void)close
{
    self.session.delegate = nil;
    [self.session disconnectFromAllPeers];
    [self.session setDataReceiveHandler:nil withContext:nil];
    self.session = nil;
}

- (void)sendNetworkPacket:(NSData*)packet {
    NSError *error = nil;
    BOOL result = NO;
    do {
        result = [self.session sendData:packet
                                toPeers:@[self.peerId]
                           withDataMode:GKSendDataReliable
                                  error:&error];
        
    } while (error || !result);
}

#pragma mark - GKSessionDelegate

-(void)session:(GKSession *)session peer:(NSString *)_peerID didChangeState:(GKPeerConnectionState)state
{
    switch(state){
        case GKPeerStateUnavailable:
        {
            if ([_peerID isEqualToString:self.session.peerID]) {
                if ([self.delegate respondsToSelector:@selector(connectionTerminated:)])
                    [self.delegate connectionTerminated:self];
            }
            break;
        }
        case GKPeerStateDisconnected:
        {
            if ([_peerID isEqualToString:self.session.peerID]) {
                if ([self.delegate respondsToSelector:@selector(connectionTerminated:)])
                    [self.delegate connectionTerminated:self];
            }
            break;
        }
        default:
            break;
    }
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(connectionTerminated:)])
        [self.delegate connectionTerminated:self];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)_peer inSession: (GKSession *)session context:(void *)context
{
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveData:)])
        [self.delegate connection:self didReceiveData:data];
}


@end
