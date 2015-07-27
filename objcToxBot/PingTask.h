//
//  PingTask.h
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TaskProtocol.h"

/**
 * Task will send "ping" message to all online friends every pingTimeInterval.
 */
@interface PingTask : NSObject <TaskProtocol>

/**
 * Minimum pingTimeInterval is equal to `execute` time.
 */
@property (assign, nonatomic) NSTimeInterval pingTimeInterval;

@end
