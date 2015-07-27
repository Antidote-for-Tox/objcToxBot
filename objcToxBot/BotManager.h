//
//  BotManager.h
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bot;

@interface BotManager : NSObject

- (void)addBot:(Bot *)bot;

- (void)start;
- (void)stop;

@end
