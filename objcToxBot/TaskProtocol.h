//
//  TaskProtocol.h
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objcTox/OCTToxConstants.h>

@class OCTManager;

@protocol TaskProtocol <NSObject>

@property (weak, nonatomic) OCTManager *manager;

@optional
/**
 * Run next iteration for the task.
 */
- (void)execute;

- (void)connectionStatusUpdate:(OCTToxConnectionStatus)connectionStatus;

@end
