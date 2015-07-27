//
//  ApproveFriendRequestTask.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "ApproveFriendRequestTask.h"
#import "OCTManager.h"
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
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type != NSFetchedResultsChangeInsert) {
        return;
    }

    OCTFriendRequest *request = [anObject RLMObject];
    NSError *error;

    if (! [self.manager.friends approveFriendRequest:request error:&error]) {
        NSLog(@"%@ approving request %@, error %@", self, request, error);
    }
}

@end
