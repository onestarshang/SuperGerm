//
//  FenceManager.h
//  SuperGerm
//
//  Created by Ariequ on 14-1-14.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "Fence.h"

@interface FenceManager : NSObject
- (void) update:(ccTime)delta;
- (void)addFence:(id)obj atPosition:(CGPoint)position;
+ (FenceManager *) sharedFenceManager;
@end
