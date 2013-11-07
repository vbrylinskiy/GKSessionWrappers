#import <Foundation/Foundation.h>

@class Connection;

@protocol ConnectionDelegate <NSObject>

- (void)connection:(Connection *)connection didReceiveData:(NSData *)data;
- (void)connectionTerminated:(Connection*)connection;

@end
