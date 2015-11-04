//
//  CallAudioTask.h
//  objcToxBot
//
//  Created by Chuong Vu on 9/4/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TaskProtocol.h"

/**
 * This task brings up a list of online friends from
 * which you can choose who to make an audio call.
 */
@interface CallAudioTask : NSObject <TaskProtocol>

@end
