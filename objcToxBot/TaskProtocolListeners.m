//
//  TaskProtocolListeners.m
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 27/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "TaskProtocolListeners.h"

#define CREATE_INVOCATION \
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:_cmd]]; \
    invocation.selector = _cmd; \
    __unused NSUInteger argumentCount = 0;

#define ADD_ARGUMENT(arg) \
    [invocation setArgument : &arg atIndex : argumentCount++];

@interface TaskProtocolListeners ()

@property (strong, nonatomic) NSMutableSet *listenersSet;
@property (strong, nonatomic) NSObject *listenersLock;

@end

@implementation TaskProtocolListeners

#pragma mark -  Lifecycle

- (instancetype)init
{
    self = [super init];

    if (! self) {
        return nil;
    }

    _listenersSet = [NSMutableSet new];
    _listenersLock = [NSObject new];

    return self;
}

#pragma mark -  Public

- (void)addListener:(id<TaskProtocol>)listener
{
    NSParameterAssert(listener);

    @synchronized(self.listenersLock) {
        [self.listenersSet addObject:listener];
    }
}

- (void)removeListener:(id<TaskProtocol>)listener
{
    NSParameterAssert(listener);

    @synchronized(self.listenersLock) {
        [self.listenersSet removeObject:listener];
    }
}

- (void)enumerateObjectsUsingBlock:(void (^)(id<TaskProtocol> listener, BOOL *stop))block
{
    NSParameterAssert(block);

    @synchronized(self.listenersLock) {
        [self.listenersSet enumerateObjectsUsingBlock:block];
    }
}

#pragma mark -  TaskProtocol

- (void)execute
{
    CREATE_INVOCATION;
    [self performInvocationOnListeners:invocation];
}

- (TaskAction *)tapAction
{
    // Generally this is worthless method. We implement it just to not to break TaskProtocol.

    CREATE_INVOCATION;
    [self performInvocationOnListeners:invocation];
    return nil;
}

- (void)connectionStatusUpdate:(OCTToxConnectionStatus)connectionStatus
{
    CREATE_INVOCATION;
    ADD_ARGUMENT(connectionStatus);
    [self performInvocationOnListeners:invocation];
}

#pragma mark -  Private

- (void)performInvocationOnListeners:(NSInvocation *)invocation
{
    @synchronized(self.listenersLock) {
        for (id<TaskProtocol> listener in self.listenersSet) {
            if ([listener respondsToSelector:invocation.selector]) {
                [invocation invokeWithTarget:listener];
            }
        }
    }
}

@end
