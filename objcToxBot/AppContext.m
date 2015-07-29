//
//  AppContext.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "AppContext.h"
#import "BotManager.h"
#import "UserDefaultsManager.h"

NSString *const kBotNamePrefix = @"bot-";

@interface AppContext ()

@property (strong, nonatomic) BotManager *botManager;
@property (strong, nonatomic) UserDefaultsManager *userDefaults;

@end

@implementation AppContext

#pragma mark -  Lifecycle

- (id)init
{
    return nil;
}

- (id)initPrivate
{
    self = [super init];

    if (! self) {
        return nil;
    }

    _botManager = [BotManager new];
    [_botManager start];

    _userDefaults = [UserDefaultsManager new];

    return self;
}

+ (instancetype)sharedContext
{
    static AppContext *instance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[AppContext alloc] initPrivate];
    });

    return instance;
}

#pragma mark -  Public

- (NSString *)botsPath
{
    static NSString *path;
    static dispatch_once_t token;

    dispatch_once(&token, ^{
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [path stringByAppendingPathComponent:@"bots"];

        NSFileManager *fileManager = [NSFileManager defaultManager];

        if (! [fileManager fileExistsAtPath:path isDirectory:NULL]) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });

    return path;
}

@end
