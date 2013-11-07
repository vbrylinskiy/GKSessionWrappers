#import "Client.h"
#import "PeerDelegate.h"

@interface Client () <ConnectionDelegate>

@property (nonatomic, strong) Connection *connection;

@end

@implementation Client

@synthesize delegate;

- (id)initWithConnection:(Connection *)connection {
    if (self = [super init]) {
        _connection = connection;
        _connection.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveSession) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Peer

- (void)leaveSession {    
    [self.connection close];
}

- (void)sendMessage:(NSData *)message {
    [self.connection sendNetworkPacket:message];
}

- (NSString *)peerId {
    return self.connection.peerId;
}

#pragma mark - ConnectionDelegate

- (void)connection:(Connection *)connection didReceiveData:(NSData *)data {
    if ([self.delegate respondsToSelector:@selector(peer:receivedData:)])
        [self.delegate peer:self receivedData:data];
}

- (void)connectionTerminated:(Connection*)connection {
    if ([self.delegate respondsToSelector:@selector(peer:disconnectedWithReason:)])
        [self.delegate peer:self disconnectedWithReason:@"Connection error occured."];
}

@end
