//
//  EchoTask.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "EchoTask.h"
#import "OCTManager.h"
#import "OCTMessageAbstract.h"
#import "OCTMessageText.h"
#import "RBQFetchedResultsController.h"

@interface EchoTask () <RBQFetchedResultsControllerDelegate>

@property (weak, nonatomic) OCTManager *manager;
@property (strong, nonatomic) RBQFetchedResultsController *controller;

@end

@implementation EchoTask

#pragma mark -  TaskProtocol

- (void)configureWithManager:(OCTManager *)manager
{
    self.manager = manager;

    RBQFetchRequest *fetchRequest = [manager.objects fetchRequestForType:OCTFetchRequestTypeMessageAbstract withPredicate:nil];
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

    OCTMessageAbstract *message = [anObject RLMObject];

    if ([message isOutgoing] || ! message.messageText) {
        return;
    }

    // workaround for deadlock in objcTox https://github.com/Antidote-for-Tox/objcTox/issues/51
    [self performSelector:@selector(sendMessageBack:) withObject:message afterDelay:0];
}

#pragma mark -  Private

- (void)sendMessageBack:(OCTMessageAbstract *)message
{
    NSError *error;

    OCTMessageAbstract *sentMessage = [self.manager.chats sendMessageToChat:message.chat
                                                                       text:message.messageText.text
                                                                       type:message.messageText.type
                                                                      error:&error];

    if (! sentMessage) {
        NSLog(@"%@ error %@", self, error);
    }
}

@end
