//
//  OnlineFriendsViewController.m
//  objcToxBot
//
//  Created by Chuong Vu on 9/5/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "OnlineFriendsViewController.h"

static NSString *const kReuseIdentifier = @"cell";
static const CGFloat kPadding = 50.0;

@interface OnlineFriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIVisualEffectView *visualView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *dismissButton;

@end

@implementation OnlineFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    [self createBlurrView];
    [self createDismissButton];
    [self setupTableView];
    [self setupConstraints];
}

- (void)createBlurrView
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

    self.visualView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.visualView.frame = self.view.frame;
    [self.view addSubview:self.visualView];
}

- (void)createDismissButton
{
    self.dismissButton = [UIButton new];
    self.dismissButton.backgroundColor = [UIColor clearColor];
    [self.dismissButton addTarget:self action:@selector(dismissButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.dismissButton.frame = self.visualView.frame;

    [self.visualView.contentView addSubview:self.dismissButton];
}

- (void)setupTableView
{
    self.tableView = [UITableView new];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReuseIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.visualView.contentView addSubview:self.tableView];
}

- (void)setupConstraints
{
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tableView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.visualView.contentView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:-kPadding];

    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tableView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.visualView.contentView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:kPadding];

    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.tableView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.visualView.contentView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0
                                                             constant:kPadding];

    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.tableView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.visualView.contentView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:-kPadding];

    [self.visualView.contentView addConstraints:@[bottom, top, left, right]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate numberOfOnlineFriends];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];

    cell.textLabel.text = [self.delegate nicknameForIndexPath:indexPath];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectFriendAtIndexPath:indexPath];
}

#pragma mark - Private

- (void)dismissButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
