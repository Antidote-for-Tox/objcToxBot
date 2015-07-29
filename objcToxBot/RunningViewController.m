//
//  RunningViewController.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 29/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import <Masonry/Masonry.h>

#import "RunningViewController.h"
#import "RunningBotCell.h"
#import "BotManager.h"
#import "Bot.h"

static NSString *const kRunningBotCellIdentifier = @"kRunningBotCellIdentifier";
static const NSTimeInterval kNotificationDuration = 2.0;

@interface RunningViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *bots;
@property (strong, nonatomic) UITableView *tableView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createViews];
    [self installConstraints];

    self.bots = [[AppContext sharedContext].botManager.bots allObjects];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.bots = [[AppContext sharedContext].botManager.bots allObjects];
    [self.tableView reloadData];
}

#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bot *bot = self.bots[indexPath.row];

    RunningBotCell *cell = [tableView dequeueReusableCellWithIdentifier:kRunningBotCellIdentifier forIndexPath:indexPath];
    cell.botIdentifier = bot.botIdentifier;
    cell.userAddress = bot.userAddress;

    switch (bot.connectionStatus) {
        case OCTToxConnectionStatusNone:
            cell.connectionStatus = NSLocalizedString(@"None", @"Running");
            cell.connectionStatusColor = [UIColor lightGrayColor];
            break;
        case OCTToxConnectionStatusUDP:
            cell.connectionStatus = NSLocalizedString(@"UDP", @"Running");
            cell.connectionStatusColor = [UIColor greenColor];
            break;
        case OCTToxConnectionStatusTCP:
            cell.connectionStatus = NSLocalizedString(@"TCP", @"Running");
            cell.connectionStatusColor = [UIColor greenColor];
            break;
    }

    return cell;
}

#pragma mark -  UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Bot *bot = self.bots[indexPath.row];
    NSString *string = [bot userAddress];

    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    pb.string = string;

    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Copied: %@", @"Running"), string];

    CWStatusBarNotification *notification = [CWStatusBarNotification new];
    [notification displayNotificationWithMessage:message forDuration:kNotificationDuration];
}

#pragma mark -  Private

- (void)createViews
{
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44.0;
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[RunningBotCell class] forCellReuseIdentifier:kRunningBotCellIdentifier];

    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 30.0)];
    header.text = NSLocalizedString(@"Tap to copy bot address", @"Running");
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont italicSystemFontOfSize:12.0];
    self.tableView.tableHeaderView = header;
}

- (void)installConstraints
{
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
