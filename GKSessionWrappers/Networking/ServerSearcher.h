//
//  ServerSearcher.h
//  GKSessionWrappers
//
//  Created by Vladislav Brylinskiy on 12.11.13.
//  Copyright (c) 2013 Vladislav Brylinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerSearcherDelegate.h"

@interface ServerSearcher : NSObject

@property (nonatomic, weak) id <ServerSearcherDelegate> delegate;

- (id)initWithSessionId:(NSString *)sessionId;

- (NSArray *)availableServers;

- (void)connectToServer:(NSString *)serverPeerId;

- (void)refresh;
- (void)startSearch;
- (void)stopSearch;

@end
