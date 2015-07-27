//
//  TaskProtocolListeners.h
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TaskProtocol.h"

/**
 * Thread safe container for TaskProtocol listeners. All TaskProtocol methods sent to instance
 * of this class will be forwarded to listeners. Before sending a method checks if listener
 * responds to it.
 */
@interface TaskProtocolListeners : NSObject <TaskProtocol>

- (void)addListener:(id<TaskProtocol>)listener;
- (void)removeListener:(id<TaskProtocol>)listener;

@end
