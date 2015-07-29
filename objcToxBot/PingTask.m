//
//  PingTask.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <objcTox/OCTManager.h>
#import <RBQFetchedResultsController/RBQFetchRequest.h>

#import "PingTask.h"

@interface PingTask ()

@property (weak, nonatomic) OCTManager *manager;
@property (strong, nonatomic) NSDate *lastPingDate;

@end

@implementation PingTask

#pragma mark -  TaskProtocol

- (void)configureWithManager:(OCTManager *)manager
{
    self.manager = manager;
    self.lastPingDate = [NSDate dateWithTimeIntervalSince1970:0];
}

- (NSString *)saveToString
{
    return [NSString stringWithFormat:@"%f", self.pingTimeInterval];
}

- (void)loadFromString:(NSString *)saveString
{
    self.pingTimeInterval = [saveString floatValue];
}

- (void)execute
{
    if (self.pingTimeInterval <= 0.0) {
        return;
    }

    NSDate *now = [NSDate date];
    NSTimeInterval timePassed = [now timeIntervalSinceDate:self.lastPingDate];

    if (timePassed < self.pingTimeInterval) {
        return;
    }

    self.lastPingDate = now;

    NSLog(@"%@ pinging", self);

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isConnected == YES"];
    RBQFetchRequest *fetchRequest = [self.manager.objects fetchRequestForType:OCTFetchRequestTypeFriend
                                                                withPredicate:predicate];

    for (OCTFriend *friend in [fetchRequest fetchObjects]) {
        OCTChat *chat = [self.manager.chats getOrCreateChatWithFriend:friend];
        NSError *error;

        OCTMessageAbstract *sentMessage = [self.manager.chats sendMessageToChat:chat
                                                                           text:@"ping"
                                                                           type:OCTToxMessageTypeNormal
                                                                          error:&error];

        if (! sentMessage) {
            NSLog(@"%@ ping friend %@, error %@", self, friend, error);
        }
    }
}

@end
