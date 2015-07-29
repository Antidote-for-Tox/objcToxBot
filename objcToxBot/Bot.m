//
//  Bot.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <objcTox/OCTManager.h>
#import <objcTox/OCTDefaultSettingsStorage.h>
#import <objcTox/OCTDefaultFileStorage.h>
#import <objcTox/OCTTox.h>

#import "Bot.h"
#import "TaskProtocolListeners.h"

@interface Bot () <OCTSubmanagerUserDelegate>

@property (strong, nonatomic) NSString *botIdentifier;

@property (strong, nonatomic) TaskProtocolListeners *listeners;
@property (strong, nonatomic) OCTManager *manager;

@end

@implementation Bot

#pragma mark -  Lifecycle

- (instancetype)init
{
    NSString *botIdentifier = [kBotNamePrefix stringByAppendingString:[[NSUUID UUID] UUIDString]];

    return [self initWithBotIdentifier:botIdentifier];
}

- (instancetype)initWithBotIdentifier:(NSString *)botIdentifier
{
    self = [super init];

    if (! self) {
        return nil;
    }

    _botIdentifier = botIdentifier;
    _listeners = [TaskProtocolListeners new];

    [self createManager];
    [self configureUser];
    [self bootstrap];

    return self;
}

#pragma mark -  Public

- (OCTToxConnectionStatus)connectionStatus
{
    return self.manager.user.connectionStatus;
}

- (NSString *)userAddress
{
    return self.manager.user.userAddress;
}

- (NSString *)userName
{
    return self.manager.user.userName;
}

- (NSString *)userStatusMessage
{
    return self.manager.user.userStatusMessage;
}

- (void)addTask:(id<TaskProtocol>)task
{
    if ([task respondsToSelector:@selector(configureWithManager:)]) {
        [task configureWithManager:self.manager];
    }

    [self.listeners addListener:task];
}

- (void)execute
{
    [self.listeners execute];
}

#pragma mark -  OCTSubmanagerUserDelegate

- (void)OCTSubmanagerUser:(OCTSubmanagerUser *)submanager connectionStatusUpdate:(OCTToxConnectionStatus)connectionStatus
{
    [self.listeners connectionStatusUpdate:connectionStatus];
}

#pragma mark -  Private

- (void)createManager
{
    OCTManagerConfiguration *configuration = [OCTManagerConfiguration defaultConfiguration];
    configuration.settingsStorage = [self settingsStorage];
    configuration.fileStorage = [self fileStorage];

    self.manager = [[OCTManager alloc] initWithConfiguration:configuration];
    self.manager.user.delegate = self;
}

- (id<OCTSettingsStorageProtocol>)settingsStorage
{
    return [[OCTDefaultSettingsStorage alloc] initWithUserDefaultsKey:self.botIdentifier];
}

- (id<OCTFileStorageProtocol>)fileStorage
{
    NSString *path = [[[AppContext sharedContext] botsPath] stringByAppendingPathComponent:self.botIdentifier];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (! [fileManager fileExistsAtPath:path isDirectory:NULL]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return [[OCTDefaultFileStorage alloc] initWithBaseDirectory:path temporaryDirectory:NSTemporaryDirectory()];
}

- (void)configureUser
{
    [self.manager.user setUserName:[NSString stringWithFormat:@"objcToxBot %@", self.botIdentifier] error:nil];
    [self.manager.user setUserStatusMessage:[NSString stringWithFormat:@"Toxcore version %@", [OCTTox version]] error:nil];
}

- (void)bootstrap
{
    [self.manager bootstrapFromHost:@"192.254.75.102"
                               port:33445
                          publicKey:@"951C88B7E75C867418ACDB5D273821372BB5BD652740BCDF623A4FA293E75D2F"
                              error:nil];

    [self.manager bootstrapFromHost:@"178.62.125.224"
                               port:33445
                          publicKey:@"10B20C49ACBD968D7C80F2E8438F92EA51F189F4E70CFBBB2C2C8C799E97F03E"
                              error:nil];

    [self.manager bootstrapFromHost:@"192.210.149.121"
                               port:33445
                          publicKey:@"F404ABAA1C99A9D37D61AB54898F56793E1DEF8BD46B1038B9D822E8460FAB67"
                              error:nil];
}

@end
