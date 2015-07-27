//
//  LogTask.h
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskProtocol.h"

/**
 * Simple task that logs itself on execute method.
 */
@interface LogTask : NSObject <TaskProtocol>

@end
