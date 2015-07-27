//
//  TestViewController.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>

#import "TestViewController.h"
#import "BotManager.h"
#import "Bot.h"
#import "LogTask.h"
#import "ApproveFriendRequestTask.h"
#import "EchoTask.h"

static const CGFloat kButtonWidth = 220.0;
static const CGFloat kButtonHeight = 40.0;

@interface TestViewController ()

@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *stopButton;
@property (strong, nonatomic) UIButton *addBotWithLogTaskButton;

@property (strong, nonatomic) BotManager *botManager;

@end

@implementation TestViewController

#pragma mark -  Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createButtons];
    [self installConstraints];

    self.botManager = [BotManager new];
}

#pragma mark -  Actions

- (void)startButtonPressed
{
    [self.botManager start];
}

- (void)stopButtonPressed
{
    [self.botManager stop];
}

- (void)addBotWithLogTaskButtonPressed
{
    Bot *bot = [Bot new];
    [bot addTask:[ApproveFriendRequestTask new]];
    [bot addTask:[EchoTask new]];

    NSLog(@"----- %@", bot.userAddress);

    [self.botManager addBot:bot];
}

#pragma mark -  Private

- (void)createButtons
{
    self.startButton = [self buttonWithTitle:NSLocalizedString(@"Start", @"TestViewController")
                                      action:@selector(startButtonPressed)];
    self.stopButton = [self buttonWithTitle:NSLocalizedString(@"Stop", @"TestViewController")
                                     action:@selector(stopButtonPressed)];
    self.addBotWithLogTaskButton = [self buttonWithTitle:NSLocalizedString(@"Add bot with log task", @"TestViewController")
                                                  action:@selector(addBotWithLogTaskButtonPressed)];
}

- (UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action
{
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    return button;
}

- (void)installConstraints
{
    [self.startButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.equalTo(kButtonWidth);
        make.height.equalTo(kButtonHeight);
    }];

    [self.stopButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startButton.bottom).offset(10.0);
        make.centerX.equalTo(self.view);
        make.width.equalTo(kButtonWidth);
        make.height.equalTo(kButtonHeight);
    }];

    [self.addBotWithLogTaskButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stopButton.bottom).offset(10.0);
        make.centerX.equalTo(self.view);
        make.width.equalTo(kButtonWidth);
        make.height.equalTo(kButtonHeight);
    }];
}

@end
