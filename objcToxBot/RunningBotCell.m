//
//  RunningBotCell.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 29/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "RunningBotCell.h"

@interface RunningBotCell ()

@property (strong, nonatomic) UILabel *botIdentifierLabel;
@property (strong, nonatomic) UILabel *connectionStatusLabel;
@property (strong, nonatomic) UILabel *userAddressLabel;

@end

@implementation RunningBotCell

#pragma mark -  Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (! self) {
        return nil;
    }

    [self createViews];
    [self installConstraints];

    return self;
}

#pragma mark -  Properties

- (void)setBotIdentifier:(NSString *)botIdentifier
{
    self.botIdentifierLabel.text = botIdentifier;
}

- (NSString *)botIdentifier
{
    return self.botIdentifierLabel.text;
}

- (void)setConnectionStatus:(NSString *)connectionStatus
{
    self.connectionStatusLabel.text = connectionStatus;
}

- (NSString *)connectionStatus
{
    return self.connectionStatusLabel.text;
}

- (void)setConnectionStatusColor:(UIColor *)connectionStatusColor
{
    self.connectionStatusLabel.textColor = connectionStatusColor;
}

- (UIColor *)connectionStatusColor
{
    return self.connectionStatusLabel.textColor;
}

- (void)setUserAddress:(NSString *)userAddress
{
    self.userAddressLabel.text = userAddress;
}

- (NSString *)userAddress
{
    return self.userAddressLabel.text;
}

#pragma mark -  Private

- (void)createViews
{
    self.botIdentifierLabel = [self createLabel];
    self.connectionStatusLabel = [self createLabel];
    self.userAddressLabel = [self createLabel];
}

- (void)installConstraints
{
    [self.botIdentifierLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];

    [self.connectionStatusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.botIdentifierLabel.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    [self.userAddressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.connectionStatusLabel.bottom);
        make.left.bottom.right.equalTo(self.contentView);
    }];
}

- (UILabel *)createLabel
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];

    return label;
}

@end
