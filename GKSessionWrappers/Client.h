#import "Peer.h"
#import <GameKit/GKSession.h>
#import "Connection.h"

@interface Client : NSObject <Peer>

- (id)initWithConnection:(Connection *)connection;

@property (nonatomic, readonly) NSString *peerId;

@end
 