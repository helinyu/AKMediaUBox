
//
//  AkAudioSessionMgr.m
//  AKMediaUBox
//
//  Created by Aka on 2017/9/14.
//  Copyright © 2017年 Aka. All rights reserved.
//

//通过引用计数俩进行控制

#import "AAudioSessionMgr.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioSession.h>

typedef NS_ENUM(NSInteger, YDAudioSessionActiveType) {
    YDAudioSessionActiveTypeDead = 0,
    YDAudioSessionActiveTypeAlive = 1,
};

@interface AKAudioSessionMgr ()

#pragma mark -- LiveAudioNum category

@property (nonatomic, assign) NSInteger liveNum;

@end

@implementation AAudioSessionMgr

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initBase];
    }
    return self;
}

- (void)initBase {
    [self _registerNotiOberser];
}

- (void)_registerNotiOberser {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioPlayerInterruptedNotify:) name:AVAudioSessionInterruptionNotification object:nil];
}


// notificaiton action methods
- (void)onAudioPlayerInterruptedNotify:(NSNotification *)noti {
//    [[NSNotificationCenter defaultCenter] postNotificationName:ydNtfAudioSessionInterruption object:nil];
    if (![noti.userInfo.allKeys containsObject:AVAudioSessionInterruptionTypeKey]) {
        return;
    }
    
    NSInteger interruptFlag =[[noti.userInfo objectForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (interruptFlag == AVAudioSessionInterruptionTypeBegan) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ydNtfAudioSessionBeginInterruption object:nil];
    }
    else if (interruptFlag == AVAudioSessionInterruptionTypeEnded){
        [self forceRescoveryActive];
//        [[NSNotificationCenter defaultCenter] postNotificationName:ydNtfAudioSessionEndInterruption object:nil];
        if (![noti.userInfo.allKeys containsObject:AVAudioSessionInterruptionOptionKey]) {
            return;
        }
        AVAudioSessionInterruptionOptions interruptionOptions = (AVAudioSessionInterruptionOptions)[[noti.userInfo objectForKey:AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (AVAudioSessionInterruptionOptionShouldResume == interruptionOptions) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:ydNtfAudioSessionEndInterruptionShouldResume object:nil];
        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:ydNtfAudioSessionEndInterruptionOther object:nil];
        }
    }
    else{}
}

- (BOOL)reduceOne {
    
    if (self.liveNum <= YDAudioSessionActiveTypeDead) {
        return NO;
    }
    
    self.liveNum--;
    if (self.liveNum == YDAudioSessionActiveTypeDead) {
        [self _updateAudioSessionState:self.liveNum];
    }
    return YES;
}

- (BOOL)increaseOne {
    self.liveNum++;
    if (self.liveNum == YDAudioSessionActiveTypeAlive) {
        [self _updateAudioSessionState:self.liveNum];
    }
    return YES;
}

- (void)_updateAudioSessionState:(NSInteger)liveNum {
    if (liveNum == YDAudioSessionActiveTypeDead) {
        [YDAudioSessionMgr _unableActive];
    }
    else {
        [YDAudioSessionMgr _enableActive];
    }
}

- (void)forceStopActive {
//    [[NSNotificationCenter defaultCenter] postNotificationName:ydNtfInactiveAudioSession object:nil];
    [YDAudioSessionMgr _unableActive];
}

- (void)forceRescoveryActive {
//    [[NSNotificationCenter defaultCenter] postNotificationName:ydNtfActiveAudioSession object:nil];
    [YDAudioSessionMgr _enableActive];
}

#pragma mark -- class methods

+ (BOOL)_commonActiceRegisterNotify:(BOOL)active {
    NSError *error = nil;
    BOOL result = [[AVAudioSession sharedInstance] setActive:active withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (error) {
        NSLog(@"error set active of audio session : %@",error);
    }
    return result;
}

+ (BOOL)_unableActive {
//    [[NSNotificationCenter defaultCenter] postNotificationName:ydAudioSessionBecomeInactive object:nil];
    return [YDAudioSessionMgr _commonActiceRegisterNotify:NO];
}

+ (BOOL)_enableActive {
    return [YDAudioSessionMgr _commonActiceRegisterNotify:YES];
}

#pragma mark -- kAudioSessionProperty_AudioCategory (应用内，应用环境)

+ (BOOL)enableCategoryAudioProcessing {
    return [YDAudioSessionMgr _enableSessionCategoryWithValue:AVAudioSessionCategoryAudioProcessing];
}

+ (BOOL)enableCategoryPlayAndRecord {
    return [YDAudioSessionMgr _enableSessionCategoryWithValue:AVAudioSessionCategoryPlayAndRecord];
}

+ (BOOL)enableCategoryRecord {
    return [YDAudioSessionMgr _enableSessionCategoryWithValue:AVAudioSessionCategoryRecord];
}

+ (BOOL)enableCategorySoloAmbient {
    return [YDAudioSessionMgr _enableSessionCategoryWithValue:AVAudioSessionCategorySoloAmbient];
}

+ (BOOL)enableCategoryAmbient {
    return [YDAudioSessionMgr _enableSessionCategoryWithValue:AVAudioSessionCategoryAmbient];
}

+ (BOOL)enableCategoryPlayback {
    return [YDAudioSessionMgr _enableSessionCategoryWithValue:AVAudioSessionCategoryPlayback];
}

+ (BOOL)_enableSessionCategoryWithValue:(NSString *const)categoryValue {
    NSError *error;
    BOOL result = [[AVAudioSession sharedInstance] setCategory:categoryValue error:&error];
    if (error) {
        NSLog(@"set catergory error : %@",error);
    }
    return result;
}

- (BOOL)_enableSessionCategoryWithValue:(NSString *const)categoryValue option:(AVAudioSessionCategoryOptions)option {
    NSError *error;
    BOOL result = [[AVAudioSession sharedInstance] setCategory:categoryValue withOptions:option error:&error];
    if (error) {
        NSLog(@"set category with option errro :%@",error);
    }
    return result;
}

#pragma mark -- AudioSession Properties (ID) act as option  （应用间 ，手机环境）

+ (BOOL)enableCategoryMixWithOthers {
    UInt32 flag = YES;
    OSStatus result = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(flag), &flag);
    if (result) {
        return NO;
        NSLog(@"result : %d --  flag : %d",(int)result,(unsigned int)flag);
    }
    return YES;
}

@end

