#import "Master.h"
#import "Connection.h"
#import "ServerDelegate.h"
#import "Server.h"
#import "Client.h"

@interface Master () <ServerDelegate>

@property(nonatomic,strong) Server* server;
@property(nonatomic,strong) NSMutableSet* clients;

@end

@implementation Master

@synthesize delegate;

- (id)init {
    
    if (self = [super init]) {
        _clients = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (NSInteger)clientsCount
{
    return [self.clients count];
}

- (NSString *)peerId {
    return [self.server peerId];
}

- (BOOL)startSession:(NSString *)sessionIdentifier {
    self.server = [[Server alloc] initWithSessionId:sessionIdentifier];
    self.server.delegate = self;
    
    if ( ! [self.server start] ) {
        self.server = nil;
        return NO;
    }
    
    return YES;
}

- (void)leaveSession {
    [self.server stop];
    self.server = nil;
    
    [self.clients removeAllObjects];
}

- (void)sendMessage:(NSData *)data {
    [self.server broadcastNetworkPacket:data];
}

- (Client *)clientForConnection:(Connection *)connection {
    return [[self.clients filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"connection == %@", connection]] anyObject];
}

#pragma mark - ServerDelegate

- (void) serverTerminated:(Server*)server reason:(NSString*)reason {
    [self leaveSession];
    if ([self.delegate respondsToSelector:@selector(peer:disconnectedWithReason:)]) {
        [self.delegate peer:self disconnectedWithReason:@"Nerwork error"];
    }
}

- (void) handleNewConnection:(Connection *)connection {
    Client *client = [[Client alloc] initWithConnection:connection];
    [self.clients addObject:connection];
    
    if ([self.delegate respondsToSelector:@selector(peerConnected:)])
        [self.delegate peerConnected:client];
}

#pragma mark - ConnectionDelegate

- (void)connection:(Connection *)connection didReceiveData:(NSData *)data {
    Client *client = [self clientForConnection:connection];
    if ([self.delegate respondsToSelector:@selector(peer:receivedData:)]) {
        [self.delegate peer:client receivedData:data];
    }
}

- (void)connectionTerminated:(Connection*)connection {
    Client *client = [self clientForConnection:connection];
    [self.clients removeObject:client];
    
    
}

@end
