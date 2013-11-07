#import <Foundation/Foundation.h>
#import "ServerDelegate.h"
#import <GameKit/GKSession.h>


@interface Server : NSObject <GKSessionDelegate>

-(id)initWithSessionId:(NSString *)sessionId;

- (BOOL)start;
- (void)stop;

- (void)broadcastNetworkPacket:(NSData*)packet;

@property(nonatomic, weak) id<ServerDelegate> delegate;
@property (nonatomic, readonly) NSString *peerId;

@end
