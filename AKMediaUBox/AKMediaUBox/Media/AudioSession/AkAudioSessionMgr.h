//
//  AkAudioSessionMgr.h
//  AKMediaUBox
//
//  Created by Aka on 2017/9/14.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INCREASE_AUDIOSESSION_ONE [[YDAudioSessionMgr shared] increaseOne]
#define REDUCE_AUDIOSESSION_ONE [[YDAudioSessionMgr shared] reduceOne]

@interface AAudioSessionMgr : NSObject

#pragma mark -- livenum
- (BOOL)reduceOne;
- (BOOL)increaseOne;

- (void)forceRescoveryActive;
- (void)forceStopActive;

@end
