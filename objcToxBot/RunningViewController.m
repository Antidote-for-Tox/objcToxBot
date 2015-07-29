//
//  RunningViewController.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 29/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "RunningViewController.h"

@interface RunningViewController ()

@end

@implementation RunningViewController

#pragma mark -  Lifecycle

- (instancetype)init
{
    self = [super init];

    if (! self) {
        return nil;
    }

    self.title = NSLocalizedString(@"Running", @"Running");

    return self;
}

@end
