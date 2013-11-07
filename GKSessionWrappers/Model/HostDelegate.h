#import <Foundation/Foundation.h>
#import "PeerDelegate.h"

@protocol Peer;

@protocol HostDelegate <PeerDelegate>

- (void)peerConnected:(id <Peer>)peer;

@end
