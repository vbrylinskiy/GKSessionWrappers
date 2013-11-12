#import <Foundation/Foundation.h>

@class ServerSearcher;
@class Connection;

@protocol ServerSearcherDelegate <NSObject>

- (void)serverSearcherDidUpdateServerList:(ServerSearcher *)serverSearcher;
- (void)serverSearcher:(ServerSearcher *)serverSearcher didCreateConnection:(Connection *)connection;
- (void)serverSearcherConnectionDidFail:(ServerSearcher *)serverSearcher;

@end
