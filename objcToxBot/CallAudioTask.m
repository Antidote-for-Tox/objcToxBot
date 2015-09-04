//
//  CallAudioTask.m
//  objcToxBot
//
//  Created by Chuong Vu on 9/4/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objcTox/OCTManager.h>
#import <objcTox/OCTSubmanagerCalls.h>
#import <objcTox/OCTSubmanagerObjects.h>
#import <objcTox/OCTSubmanagerChats.h>

#import "CallAudioTask.h"
#import "TaskAction.h"
#import "RBQFetchedResultsController.h"

@interface CallAudioTask ()

@property (weak, nonatomic) OCTManager *manager;
@property (strong, nonatomic) RBQFetchedResultsController *controller;

@end

@implementation CallAudioTask

- (void)configureWithManager:(OCTManager *)manager
{
    self.manager = manager;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"connectionStatus != %d", OCTToxConnectionStatusNone];
    RBQFetchRequest *fetchRequest = [manager.objects
                                     fetchRequestForType:OCTFetchRequestTypeFriend
                                           withPredicate:predicate];
    self.controller = [[RBQFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                             sectionNameKeyPath:nil
                                                                      cacheName:nil];
}

- (TaskAction *)tapAction
{
    __weak CallAudioTask *weakSelf = self;

    TaskAction *action = [TaskAction new];
    action.name = NSLocalizedString(@"Call friends", @"CallFriendTask");
    action.notificationText = [NSString stringWithFormat:NSLocalizedString(@"Called friends", @"CallFriendTask")];
    action.action = ^{
        CallAudioTask *strongSelf = weakSelf;
        [strongSelf.controller performFetch];
        RLMResults *onlineFriends = [self.controller fetchedObjects];

        for (OCTFriend *friend in onlineFriends) {
            OCTChat *chat = [strongSelf.manager.chats getOrCreateChatWithFriend:friend];


            [strongSelf.manager.calls callToChat:chat
                                     enableAudio:YES
                                     enableVideo:NO
                                           error:nil];
        }
    };

    return action;
}

@end
