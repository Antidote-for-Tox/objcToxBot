//
//  CreateBotViewController.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "CreateBotViewController.h"

@interface CreateBotViewController ()

@end

@implementation CreateBotViewController

#pragma mark -  Lifecycle

- (instancetype)init
{
    self = [super init];

    if (! self) {
        return nil;
    }

    self.title = NSLocalizedString(@"Create bot", @"Create Bot");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

@end
