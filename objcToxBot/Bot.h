//
//  Bot.h
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objcTox/OCTToxConstants.h>

@protocol TaskProtocol;

@interface Bot : NSObject

@property (strong, nonatomic, readonly) NSString *botIdentifier;

- (OCTToxConnectionStatus)connectionStatus;
- (NSString *)userAddress;
- (NSString *)userName;
- (NSString *)userStatusMessage;

- (void)addTask:(id<TaskProtocol>)task;

/**
 * Run next iteration for all bot tasks.
 */
- (void)execute;

@end
