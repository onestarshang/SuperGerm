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

-(void)addFenceInTileMap:(CCTMXTiledMap *)tileMap
{
    for (CCTMXObjectGroup* objectGroup in [tileMap objectGroups])
    {
        for( id object in [objectGroup objects] )
        {
            
            NSString* groupName = [objectGroup groupName];
            Class fenceClass = NSClassFromString(groupName);
            NSObject* obj = [[[fenceClass alloc] init] autorelease];
            if (fenceClass && [obj isKindOfClass:[Fence class]])
            {
                int x = [object[@"x"] integerValue];
                int y = [object[@"y"] integerValue];
                
                Fence* fence = (Fence*)obj;
                [[[ControlCenter mapManager] actionSpriteLayer] addChild:fence];
                [fence setPosition:ccp((x + tileMap.tileSize.width/2)/2, y/2)];
                [fence setupBody];
                //            [fence start];
                
                [_fences addObject:fence];
            }
		}
    }
}

-(void) update:(ccTime)delta
{
    Player* _player = [ControlCenter player];
    for(int i=0;i<_fences.count;i++)
    {
        Fence *fence = [_fences objectAtIndex:i];
        if (fabs(fence.position.x - _player.position.x) < SCREEN.width*2/3 && ![fence isAwake])
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
