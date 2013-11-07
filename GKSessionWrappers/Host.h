#import <Foundation/Foundation.h>
#import "Peer.h"
#import "HostDelegate.h"


@protocol Host <Peer>

@property (nonatomic, weak) id <HostDelegate> delegate;

- (BOOL)startSession:(NSString *)sessionIdentifier;

@end
