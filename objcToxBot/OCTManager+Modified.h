//
//  OCTManager+Modified.h
//  objcToxBot
//
//  Created by Chuong Vu on 7/29/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <objcTox/OCTManager.h>

@interface OCTManager (Modified)

/**
 * Submanager with all video/calling methods.
 */
@property (strong, nonatomic, readwrite) OCTSubmanagerCalls *calls;

@end