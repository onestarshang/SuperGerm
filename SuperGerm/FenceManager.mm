//
//  FenceManager.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-14.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "FenceManager.h"
#import "ControlCenter.h"

@implementation FenceManager
{
    NSMutableArray* _fences;
}

-(instancetype)init
{
    if (self = [super init]) {
        _fences = [[NSMutableArray alloc] init];
    }
    return  self;
}

- (void)addFence:(id)obj atPosition:(CGPoint)position
{
    Fence* fence = (Fence*)obj;
    [[[ControlCenter mapManager] actionSpriteLayer] addChild:fence];
    [fence setPosition:position];
    [fence setupBody];
    [_fences addObject:fence];

}

-(void) update:(ccTime)delta
{
//    Player* _player = [ControlCenter player];
    for(int i=0;i<_fences.count;i++)
    {
        Fence *fence = [_fences objectAtIndex:i];
        if ([fence isInScreen] && ![fence isAwake])
        {
            [fence setAwake:YES];
            [fence start];
        }
    }
}

-(void)dealloc
{
    [_fences release];
    _fences = nil;
    [super dealloc];
}

static FenceManager *instance_ = nil;
+ (FenceManager *) sharedFenceManager
{
    if (!instance_) {
        instance_ = [[FenceManager alloc] init];
    }
    return instance_;
}

@end
