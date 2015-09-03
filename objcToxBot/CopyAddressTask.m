//
//  CopyAddressTask.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 03/09/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objcTox/OCTManager.h>
#import <objcTox/OCTSubmanagerUser.h>

#import "CopyAddressTask.h"
#import "TaskAction.h"

@interface CopyAddressTask ()

@property (weak, nonatomic) OCTManager *manager;

@end

@implementation CopyAddressTask

#pragma mark -  TaskProtocol

- (void)configureWithManager:(OCTManager *)manager
{
    self.manager = manager;
}

- (TaskAction *)tapAction
{
    __weak CopyAddressTask *weakSelf = self;

    TaskAction *action = [TaskAction new];
    action.name = NSLocalizedString(@"Copy address", @"CopyAddressTask");
    action.notificationText = [NSString stringWithFormat:NSLocalizedString(@"Copied: %@", @"CopyAddressTask"),
                               self.manager.user.userAddress];
    action.action = ^{
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        pb.string = weakSelf.manager.user.userAddress;
    };

    return action;
}

@end
