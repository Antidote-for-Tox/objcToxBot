//
//  ExistingViewController.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 29/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <BlocksKit/NSSet+BlocksKit.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import <Masonry/Masonry.h>

#import "ExistingViewController.h"
#import "BotManager.h"
#import "Bot.h"

static NSString *const kReuseIdentifier = @"kReuseIdentifier";

@interface ExistingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *notLoadedBots;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ExistingViewController

#pragma mark -  Lifecycle

- (instancetype)init
{
    self = [super init];

    if (! self) {
        return nil;
    }

    self.title = NSLocalizedString(@"Existing", @"Existing");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reloadBots];

    [self createViews];
    [self installConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self reloadBots];
    [self.tableView reloadData];
}

#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notLoadedBots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.notLoadedBots[indexPath.row];

    return cell;
}

#pragma mark -  UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.notLoadedBots[indexPath.row];

    Bot *bot = [[Bot alloc] initWithBotIdentifier:identifier];

    [[AppContext sharedContext].botManager addBot:bot];

    [self reloadBots];
    [self.tableView reloadData];
}

#pragma mark -  Private

- (void)reloadBots
{
    NSString *botsPath = [[AppContext sharedContext] botsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSSet *runningBotIdentifiers = [[[[AppContext sharedContext] botManager] bots] bk_map:^id (Bot *bot) {
        return bot.botIdentifier;
    }];

    NSArray *notLoadedBots = [fileManager contentsOfDirectoryAtPath:botsPath error:nil];
    notLoadedBots = [[notLoadedBots bk_select:^BOOL (NSString *identifier) {
        return [identifier hasPrefix:kBotNamePrefix];
    }] bk_reject:^BOOL (NSString *identifier) {
        return [runningBotIdentifiers containsObject:identifier];
    }];

    self.notLoadedBots = notLoadedBots;
}

- (void)createViews
{
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelection = YES;
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReuseIdentifier];
}

- (void)installConstraints
{
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
