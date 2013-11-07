#import <Foundation/Foundation.h>

@protocol PeerDelegate;

@protocol Peer <NSObject>

@property (nonatomic, weak) id <PeerDelegate> delegate;

- (void)leaveSession;
- (void)sendMessage:(NSData *)message;
- (NSString *)peerId;

@end
