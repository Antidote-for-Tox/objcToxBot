//
//  TaskAction.h
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 03/09/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskAction : NSObject

@property (copy, nonatomic, nonnull) NSString *name;
@property (copy, nonatomic, nonnull) NSString *notificationText;
@property (copy, nonatomic, nonnull) void (^action)();

@end
