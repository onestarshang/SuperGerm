//
//  PropManager.m
//  SuperGerm
//
//  Created by Ariequ on 14-3-7.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "PropManager.h"
#include "Prop.h"
#include "ControlCenter.h"
#include "SimpleAudioEngine.h"

@implementation PropManager
{
    int _coinCount;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"coin.mp3"];
    }
    return self;
}

-(void)addPropInTileMap:(CCTMXTiledMap *)tileMap
{
    for (CCTMXObjectGroup* objectGroup in [tileMap objectGroups])
    {
        for( id object in [objectGroup objects] )
        {
            
            NSString* groupName = [objectGroup groupName];
            Class propClass = NSClassFromString(groupName);
            NSObject* obj = [[[propClass alloc] init] autorelease];
            if (propClass && [obj isKindOfClass:[Prop class]])
            {
                int x = [object[@"x"] integerValue];
                int y = [object[@"y"] integerValue];
                
                Prop* prop = (Prop*)obj;
                [[[ControlCenter mapManager] actionSpriteLayer] addChild:prop];
                [prop setPosition:ccp((x + tileMap.tileSize.width/2)/2, (y + tileMap.tileSize.height/2)/2)];
                [prop setupBody];
            }
		}
    }
}

- (void)addCoin
{
    _coinCount++;
}

- (int)getCoinCount
{
    return _coinCount;
}

static PropManager *instance_ = nil;
+ (PropManager *) sharedPropManager
{
    if (!instance_) {
        instance_ = [[PropManager alloc] init];
    }
    return instance_;
}


@end
