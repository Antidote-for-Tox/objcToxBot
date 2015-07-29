//
//  UserDefaultsManager.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 29/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "UserDefaultsManager.h"

@implementation UserDefaultsManager

/**
 * theProperty - property without "u" prefix
 *
 * Example:
 * @property NSString *uMyString;
 *
 * GENERATE_OBJECT(MyString, kMyStringKey, NSString *)
 */
#define GENERATE_OBJECT(theProperty, theKey, theType) \
    - (void)setU ## theProperty:(theType)object \
    { \
        @synchronized(self) { \
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; \
            [defaults setObject:object forKey:theKey]; \
            [defaults synchronize]; \
        } \
    } \
\
    - (theType)u ## theProperty \
    { \
        @synchronized(self) { \
            return [[NSUserDefaults standardUserDefaults] objectForKey:theKey]; \
        } \
    }

GENERATE_OBJECT(SelectedTaskClassPathes, @"SelectedTaskClassPathes", NSArray *)

@end
