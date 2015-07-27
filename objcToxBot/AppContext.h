//
//  AppContext.h
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BotManager;

@interface AppContext : NSObject

+ (instancetype)sharedContext;

@property (strong, nonatomic, readonly) BotManager *botManager;

@end
