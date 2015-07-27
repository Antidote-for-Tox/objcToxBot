//
//  BotManager.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "BotManager.h"
#import "Bot.h"

@interface BotManager()

@property (assign, atomic) BOOL isRunning;

@property (strong, nonatomic) NSMutableSet *botsSet;
@property (strong, nonatomic) NSObject *botsLock;

@property (strong, nonatomic) dispatch_queue_t queue;

@end

@implementation BotManager

#pragma mark -  Lifecycle

- (instancetype)init
{
    self = [super init];

    if (! self) {
        return nil;
    }

    _queue = dispatch_queue_create("BotManager queue", NULL);
    _botsSet = [NSMutableSet new];
    _botsLock = [NSObject new];

    return self;
}

#pragma mark -  Public

- (void)addBot:(Bot *)bot
{
    NSParameterAssert(bot);

    @synchronized(self.botsLock) {
        [self.botsSet addObject:bot];
    }
}

- (void)start
{
    if (self.isRunning) {
        return;
    }
    self.isRunning = YES;

    dispatch_async(self.queue, ^{
        while (self.isRunning) {
            @synchronized(self.botsLock) {
                for (Bot *bot in self.botsSet) {
                    [bot execute];
                }
            }
        }
    });
}

- (void)stop
{
    self.isRunning = NO;
}

#pragma mark -  Private

@end
