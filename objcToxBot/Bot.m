//
//  Bot.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import <objcTox/OCTDefaultFileStorage.h>
#import <objcTox/OCTDefaultSettingsStorage.h>
#import <objcTox/OCTManager.h>
#import <objcTox/OCTSubmanagerBootstrap.h>
#import <objcTox/OCTSubmanagerUser.h>
#import <objcTox/OCTManagerConfiguration.h>
#import <objcTox/OCTTox.h>

#import "Bot.h"
#import "TaskProtocolListeners.h"
#import "TaskAction.h"
#import "AppDelegate.h"

static const NSTimeInterval kNotificationDuration = 2.0;

static NSString *const kTaskSaveSuffix = @"-tasks";
static NSString *const kTaskClassName = @"kTaskClassName";
static NSString *const kTaskSaveString = @"kTaskSaveString";

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
    [self loadSavedTasks];

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
    [self addTask:task save:YES];
}

- (void)execute
{
    [self.listeners execute];
}

- (void)didTapOnBot
{
    NSMutableArray *actions = [NSMutableArray new];

    [self.listeners enumerateObjectsUsingBlock:^(id < TaskProtocol > listener, BOOL *stop) {
        if ([listener respondsToSelector:@selector(tapAction)]) {
            [actions addObject:[listener tapAction]];
        }
    }];

    if (! actions.count) {
        // nothing to do here
        return;
    }

    if (actions.count == 1) {
        [self runAction:[actions firstObject]];
        return;
    }

    // multiple actions

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Select action", @"Bot")
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    for (TaskAction *ta in actions) {
        [alert addAction:[UIAlertAction actionWithTitle:ta.name style:UIAlertActionStyleDefault handler:^(UIAlertAction *_) {
            [self runAction:ta];
        }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Bot")
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
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

    self.manager = [[OCTManager alloc] initWithConfiguration:configuration error:nil];
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
    [self.manager.bootstrap addPredefinedNodes];
    [self.manager.bootstrap bootstrap];
}

- (void)loadSavedTasks
{
    NSString *key = [self.botIdentifier stringByAppendingString:kTaskSaveSuffix];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:key];

    if (! array) {
        return;
    }

    for (NSDictionary *dict in array) {
        Class class = NSClassFromString(dict[kTaskClassName]);
        NSString *saveString = dict[kTaskSaveString];

        id<TaskProtocol> task = [class new];

        if (saveString && [task respondsToSelector:@selector(loadFromString:)]) {
            [task loadFromString:saveString];
        }

        [self addTask:task save:NO];
    }
}

- (void)addTask:(id<TaskProtocol>)task save:(BOOL)save
{
    if ([task respondsToSelector:@selector(configureWithManager:)]) {
        [task configureWithManager:self.manager];
    }

    [self.listeners addListener:task];

    if (! save) {
        return;
    }

    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    dictionary[kTaskClassName] = NSStringFromClass([task class]);

    if ([task respondsToSelector:@selector(saveToString)]) {
        dictionary[kTaskSaveString] = [task saveToString];
    }

    NSString *key = [self.botIdentifier stringByAppendingString:kTaskSaveSuffix];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:key] ?: @[];

    array = [array arrayByAddingObject:[dictionary copy]];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
}

- (void)runAction:(TaskAction *)action
{
    action.action();

    CWStatusBarNotification *notification = [CWStatusBarNotification new];
    [notification displayNotificationWithMessage:action.notificationText forDuration:kNotificationDuration];
}

@end
