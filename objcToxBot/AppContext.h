//
//  AppContext.h
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kBotNamePrefix;

@class BotManager;
@class UserDefaultsManager;

@interface AppContext : NSObject

+ (instancetype)sharedContext;

@property (strong, nonatomic, readonly) BotManager *botManager;
@property (strong, nonatomic, readonly) UserDefaultsManager *userDefaults;

- (NSString *)botsPath;

@end
