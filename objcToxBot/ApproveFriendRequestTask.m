//
//  ApproveFriendRequestTask.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <objcTox/OCTFriendRequest.h>
#import <objcTox/OCTManager.h>
#import <objcTox/OCTSubmanagerFriends.h>
#import <objcTox/OCTSubmanagerObjects.h>

#import "ApproveFriendRequestTask.h"
#import "RBQFetchedResultsController.h"

@interface ApproveFriendRequestTask () <RBQFetchedResultsControllerDelegate>

@property (weak, nonatomic) OCTManager *manager;
@property (strong, nonatomic) RBQFetchedResultsController *controller;

@end

@implementation ApproveFriendRequestTask

#pragma mark -  TaskProtocol

- (void)configureWithManager:(OCTManager *)manager
{
    self.manager = manager;

    RBQFetchRequest *fetchRequest = [manager.objects fetchRequestForType:OCTFetchRequestTypeFriendRequest withPredicate:nil];
    self.controller = [[RBQFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                             sectionNameKeyPath:nil
                                                                      cacheName:nil];
    self.controller.delegate = self;
    [self.controller performFetch];
}

#pragma mark -  RBQFetchedResultsControllerDelegate

- (void) controller:(RBQFetchedResultsController *)controller
    didChangeObject:(RBQSafeRealmObject *)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(RBQFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type != RBQFetchedResultsChangeInsert) {
        return;
    }

    OCTFriendRequest *request = [anObject RLMObject];

    // workaround for deadlock in objcTox https://github.com/Antidote-for-Tox/objcTox/issues/51
    [self performSelector:@selector(approveRequest:) withObject:request afterDelay:0];
}

- (void)approveRequest:(OCTFriendRequest *)request
{
    NSError *error;

    if (! [self.manager.friends approveFriendRequest:request error:&error]) {
        NSLog(@"%@ approving request %@, error %@", self, request, error);
    }
}

@end
