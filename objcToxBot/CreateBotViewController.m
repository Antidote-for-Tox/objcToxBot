//
//  CreateBotViewController.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "CreateBotViewController.h"
#import "BotManager.h"
#import "Bot.h"
#import "ApproveFriendRequestTask.h"
#import "EchoTask.h"
#import "LogTask.h"
#import "PingTask.h"

static NSString *const kSelectTaskReuseIdentifier = @"kSelectTaskReuseIdentifier";

static const CGFloat kButtonHeight = 40.0;

@interface CreateBotViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *taskClasses;
@property (strong, nonatomic) NSMutableArray *selectedTaskClassPathes;

@property (strong, nonatomic) UITableView *selectTaskTableView;
@property (strong, nonatomic) UIButton *createBotButton;

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

    _taskClasses = @[
        [ApproveFriendRequestTask class],
        [EchoTask class],
        [LogTask class],
        [PingTask class],
    ];
    _selectedTaskClassPathes = [NSMutableArray new];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createViews];
    [self installConstraints];
}

#pragma mark -  Actions

- (void)createBotButtonPressed
{
    if (! self.selectedTaskClassPathes.count) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot create bot", @"Create Bot")
                                    message:NSLocalizedString(@"No tasks selected", @"Create Bot")
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", @"Create Bot")
                          otherButtonTitles:nil] show];
        return;
    }

    Bot *bot = [Bot new];

    for (NSIndexPath *path in self.selectedTaskClassPathes) {
        [bot addTask:[self createTaskFromPath:path]];
    }

    [[AppContext sharedContext].botManager addBot:bot];
}

#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.selectTaskTableView]) {
        return self.taskClasses.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.selectTaskTableView]) {
        return [self selectTaskCellForRowAtIndexPath:indexPath];
    }

    return [UITableViewCell new];
}

#pragma mark -  UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.selectTaskTableView]) {
        if ([self.selectedTaskClassPathes containsObject:indexPath]) {
            [self.selectedTaskClassPathes removeObject:indexPath];
        }
        else {
            [self.selectedTaskClassPathes addObject:indexPath];
        }

        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark -  Private

- (void)createViews
{
    self.selectTaskTableView = [UITableView new];
    self.selectTaskTableView.delegate = self;
    self.selectTaskTableView.dataSource = self;
    self.selectTaskTableView.allowsMultipleSelection = YES;
    [self.view addSubview:self.selectTaskTableView];

    [self.selectTaskTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSelectTaskReuseIdentifier];

    self.createBotButton = [UIButton new];
    [self.createBotButton setTitle:NSLocalizedString(@"Create Bot", @"Create Bot") forState:UIControlStateNormal];
    [self.createBotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.createBotButton.backgroundColor = self.view.tintColor;
    [self.createBotButton addTarget:self
                             action:@selector(createBotButtonPressed)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createBotButton];
}

- (void)installConstraints
{
    [self.selectTaskTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.view);
        make.right.equalTo(self.view.centerX);
    }];

    [self.createBotButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.left.equalTo(self.view.centerX);
        make.height.equalTo(kButtonHeight);
    }];
}

- (UITableViewCell *)selectTaskCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = self.taskClasses[indexPath.row];

    UITableViewCell *cell = [self.selectTaskTableView dequeueReusableCellWithIdentifier:kSelectTaskReuseIdentifier
                                                                           forIndexPath:indexPath];
    cell.textLabel.text = NSStringFromClass(class);

    if ([self.selectedTaskClassPathes containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;

    }

    return cell;
}

- (id<TaskProtocol>)createTaskFromPath:(NSIndexPath *)path
{
    Class class = self.taskClasses[path.row];
    id<TaskProtocol> task = [class new];

    if ([task isKindOfClass:[PingTask class]]) {
        PingTask *ping = task;
        ping.pingTimeInterval = 10.0;
    }

    return task;
}

@end
