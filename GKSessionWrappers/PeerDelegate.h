#import <Foundation/Foundation.h>

@protocol Peer;

@protocol PeerDelegate <NSObject>

- (void)peer:(id <Peer>)peer disconnectedWithReason:(NSString*)string;
- (void)peer:(id <Peer>)peer receivedData:(NSData *)data;

@end
