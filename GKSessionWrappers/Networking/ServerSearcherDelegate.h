//
//  ServerSearcherDelegate.h
//  GKSessionWrappers
//
//  Created by Vladislav Brylinskiy on 12.11.13.
//  Copyright (c) 2013 Vladislav Brylinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServerSearcher;
@class Connection;

@protocol ServerSearcherDelegate <NSObject>

- (void)serverSearcherDidUpdateServerList:(ServerSearcher *)serverSearcher;
- (void)serverSearcher:(ServerSearcher *)serverSearcher didCreateConnection:(Connection *)connection;
- (void)serverSearcherConnectionDidFail:(ServerSearcher *)serverSearcher;

@end
