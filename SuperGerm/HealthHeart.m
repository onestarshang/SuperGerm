//
//  HealthHeart.m
//  SuperGerm
//
//  Created by Ariequ on 14-2-23.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "HealthHeart.h"

@implementation HealthHeart
{
    int _totalBlood;
    int _bloodGap;
    float _currentBlood;
}

- (instancetype)initWithTotalBlood:(int)totalBlood
{
    self = [super init];
    if (self) {
        _totalBlood = totalBlood;
        _bloodGap = 70;
        [self drawBlood:_totalBlood];
        self.scale = 0.5;
    }
    return self;
}

- (void)drawBlood:(float)blood
{
    if (blood == _currentBlood) {
        return;
    }
    
    _currentBlood = blood;
    [self removeAllChildrenWithCleanup:YES];
    int full = (int)blood;
    for (int i=1; i<=_totalBlood; i++) {
        
        if (i <= full) {
            CCSprite *sprite = [[CCSprite alloc] initWithSpriteFrameName:@"Blood_1.png"];
            [self addChild:sprite];
            [sprite setPosition:ccp(_bloodGap*i, 0)];
        }
        
        else if (i - blood == 0.5) {
            CCSprite *sprite = [[CCSprite alloc] initWithSpriteFrameName:@"Blood_0.5.png"];
            [self addChild:sprite];
            [sprite setPosition:ccp(_bloodGap*i, 0)];
        }
        else
        {
            CCSprite *sprite = [[CCSprite alloc] initWithSpriteFrameName:@"Blood_0.png"];
            [self addChild:sprite];
            [sprite setPosition:ccp(_bloodGap*i, 0)];

        }
    }
    
}

@end
