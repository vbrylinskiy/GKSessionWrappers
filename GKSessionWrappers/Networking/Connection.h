#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"
#import <GameKit/GKSession.h>

@interface Connection : NSObject <GKSessionDelegate>

@property (nonatomic, weak) id <ConnectionDelegate> delegate;
@property (nonatomic, readonly, copy) NSString *peerId;

- (id)initWithSession:(GKSession *)session peerID:(NSString *)peerID;
- (void)close;

- (void)sendNetworkPacket:(NSData*)packet;

@end
