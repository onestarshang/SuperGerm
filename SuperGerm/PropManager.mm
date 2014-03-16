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

- (void)addProp:(id)obj atPositon:(CGPoint)position
{
    Prop* prop = (Prop*)obj;
    [[[ControlCenter mapManager] actionSpriteLayer] addChild:prop];
    [prop setPosition:position];
    [prop setupBody];
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
