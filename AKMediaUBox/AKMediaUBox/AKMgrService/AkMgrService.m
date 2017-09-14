//
//  AkMgrService.m
//  AKMediaUBox
//
//  Created by Aka on 2017/9/14.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import "AkMgrService.h"

@interface AkMgrService ()

@property (nonatomic, strong) NSMutableDictionary *mgrMap;

@end

@implementation AkMgrService

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [self new];
    });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mgrMap = @{}.mutableCopy;
    }
    return self;
}

- (id)serviceWithMgr:(Class)class {
    NSObject *mgr = _mgrMap[NSStringFromClass(class)];
    if (!mgr) {
        mgr = [class new];
        [_mgrMap setObject:mgr forKey:NSStringFromClass(class)];
    }
    return mgr;
}

@end
