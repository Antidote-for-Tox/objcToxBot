//
//  BotManager.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CWStatusBarNotification/CWStatusBarNotification.h>

#import "BotManager.h"
#import "Bot.h"

static const NSTimeInterval kTickInterval = 1.0;
static const NSTimeInterval kNotificationDuration = 2.0;

@interface BotManager ()

@property (strong, nonatomic) NSMutableSet *botsSet;
@property (strong, nonatomic) NSObject *botsLock;

@property (strong, nonatomic) dispatch_source_t timer;

@end

@implementation BotManager

#pragma mark -  Lifecycle

- (instancetype)init
{
    self = [super init];

    if (! self) {
        return nil;
    }

    _botsSet = [NSMutableSet new];
    _botsLock = [NSObject new];

    return self;
}

#pragma mark -  Public

- (NSSet *)bots
{
    @synchronized(self.botsLock) {
        return [self.botsSet copy];
    }
}

- (void)addBot:(Bot *)bot
{
    NSParameterAssert(bot);

    @synchronized(self.botsLock) {
        [self.botsSet addObject:bot];
    }
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Bot created! %@", @"Create Bot"),
                         bot.botIdentifier];

    CWStatusBarNotification *notification = [CWStatusBarNotification new];
    [notification displayNotificationWithMessage:message forDuration:kNotificationDuration];
}

- (void)start
{
    if (self.timer) {
        return;
    }

    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());

    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), kTickInterval * NSEC_PER_SEC, 0);

    __weak BotManager *weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        @synchronized(weakSelf.botsLock) {
            for (Bot *bot in weakSelf.botsSet) {
                [bot execute];
            }
        }
    });

    dispatch_resume(self.timer);
}

- (void)stop
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

#pragma mark -  Private

@end
