#import <Foundation/Foundation.h>
#import "Host.h"


@interface Master : NSObject <Host> 

- (NSInteger)clientsCount;
- (NSString *)peerId;

@end
