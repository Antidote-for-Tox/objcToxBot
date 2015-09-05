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
#import "OnlineFriendsViewController.h"
#import "AppDelegate.h"

@interface CallAudioTask () <OnlineFriendsViewControllerDelegate>

@property (weak, nonatomic) OCTManager *manager;
@property (strong, nonatomic) RBQFetchedResultsController *controller;
@property (strong, nonatomic) OnlineFriendsViewController *friendsVC;

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
    action.name = NSLocalizedString(@"Make audio call", @"CallFriendTask");
    action.notificationText = [NSString stringWithFormat:NSLocalizedString(@"Pick a friend to call!", @"CallFriendTask")];
    action.action = ^{
        CallAudioTask *strongSelf = weakSelf;
        [strongSelf.controller performFetch];
        [strongSelf createPopupViewController];

        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window.rootViewController presentViewController:strongSelf.friendsVC
                                                         animated:YES completion:nil];
    };

    return action;
}

#pragma mark - OnlineFriendsViewController

- (NSInteger)numberOfOnlineFriends
{
    return [[self.controller fetchedObjects] count];
}

- (NSString *)nicknameForIndexPath:(NSIndexPath *)indexPath
{
    OCTFriend *friend = [[self.controller fetchedObjects] objectAtIndex:indexPath.row];

    return friend.nickname;
}

- (void)didSelectFriendAtIndexPath:(NSIndexPath *)indexPath
{
    OCTFriend *friend = [[self.controller fetchedObjects] objectAtIndex:indexPath.row];
    OCTChat *chat = [self.manager.chats getOrCreateChatWithFriend:friend];
    [self.manager.calls callToChat:chat enableAudio:YES enableVideo:NO error:nil];

    [self.friendsVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)createPopupViewController
{
    self.friendsVC = [OnlineFriendsViewController new];
    self.friendsVC.modalInPopover = YES;
    self.friendsVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.friendsVC.delegate = self;
}

@end
