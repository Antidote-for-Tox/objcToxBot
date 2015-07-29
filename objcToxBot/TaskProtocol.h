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

- (void)configureWithManager:(OCTManager *)manager;

/**
 * Implement following methods to add ability to save/load task from/to string.
 */
- (NSString *)saveToString;
- (void)loadFromString:(NSString *)saveString;

/**
 * Run next iteration for the task.
 */
- (void)execute;

- (void)connectionStatusUpdate:(OCTToxConnectionStatus)connectionStatus;

@end
