#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"

@class Server, Connection;

@protocol ServerDelegate <ConnectionDelegate>

- (void)serverTerminated:(Server*)server reason:(NSString*)reason;
- (void)handleNewConnection:(Connection*)connection;

@end
