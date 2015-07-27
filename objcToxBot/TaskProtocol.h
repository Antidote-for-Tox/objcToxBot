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

@optional

#pragma mark -  Called once

/**
 * This method will be called only once after adding task to bot.
 */
- (void)configureWithManager:(OCTManager *)manager;

#pragma mark -  Called multiple times

/**
 * Run next iteration for the task.
 */
- (void)execute;

- (void)connectionStatusUpdate:(OCTToxConnectionStatus)connectionStatus;

@end
