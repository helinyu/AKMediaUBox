//
//  AkMgrService.h
//  AKMediaUBox
//
//  Created by Aka on 2017/9/14.
//  Copyright © 2017年 Aka. All rights reserved.
//

#define SERVICE_MGR(classname) ((classname *)[[AkMgrService shared] serviceWithMgr:classname.class])

#import <Foundation/Foundation.h>

@interface AkMgrService : NSObject

+ (instancetype)shared;
- (id)serviceWithMgr:(Class)class;

@end

#import "AKSegmentAudioMgr.h"
#import "AKAudioMgr.h"


