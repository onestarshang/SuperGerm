//
//  Megama.m
//  SuperGerm
//
//  Created by Ariequ on 14-3-9.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "Megama.h"

@implementation Megama
-(instancetype)init
{
    if (self = [super initWithSpriteFrameName:@"Megma/0.png"])
    {
        
    }
    return self;
}

-(void) setupBody
{
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
    ballBodyDef.userData = self;
    _body = [WorldLayer world]->CreateBody(&ballBodyDef);
    _body->SetGravityScale(0);
    [self replaceBodyShape:_body withShapeName:@"megma"];
}


-(void)start
{
//    [self scheduleUpdate];
    
    AnimationWapper *wapper = [[[AnimationWapper alloc] init] autorelease];
    CCAction *megama = [wapper actionWithPrefix:@"Megma/" suffix:@".png" frame:12 frameDelay:0.1 target:self callback:nil];
    [self runAction:[CCRepeatForever actionWithAction:(CCActionInterval *)megama]];
    
}

-(void)beginContactWithPlayer:(GB2Contact *)contact
{
    [ControlCenter player].health = 0;
}

-(void)update:(ccTime)delta
{
    [self sythShapePosition];
}

-(void)stop
{
    [self unscheduleUpdate];
}

@end
