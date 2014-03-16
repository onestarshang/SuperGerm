//
//  Thorn.m
//  SuperGerm
//
//  Created by Ariequ on 14-2-16.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "Thorn.h"

@implementation Thorn
{
    float ATTACKLASTTIME;
}
-(instancetype)init
{
    if (self = [super initWithSpriteFrameName:@"thorn/1.png"])
    {
        ATTACKLASTTIME = 0.6;
        WAITINGMODELLASTTIME = 2;
        self.health = 100;
        _isReadyToAttack = YES;
        self.awakeDistance = SCREEN.width/2;
        self.ATK = 0.5;
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
    _body->SetFixedRotation(YES);
    [self replaceBodyShape:_body withShapeName:@"thorn"];
    _body->SetAwake(YES);
//    _body->SetGravityScale(0);
}

- (void)hitCallback
{
    _germState = kState_NOthing;
}

- (void)playHitAnimation
{
    if (_germState != kState_Hitting) {
        _germState = kState_Hitting;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction *hitAction = [actionProvider actionWithPrefix:@"thorn/" suffix:@".png" frame:3 frameDelay:0.2 target:self callback:@selector(hitCallback)];
        [self stopAllActions];
        [self runAction:hitAction];
    }
}

- (void)playStandByAnimation
{
    if (_germState != kState_Standing) {
        _germState = kState_Standing;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction* standbyAction = [actionProvider actionWithPrefix:@"thorn/" suffix:@".png" frame:1 frameDelay:0.1 target:self callback:@selector(standbyCallback)];
        [self stopAllActions];
        [self runAction:standbyAction];
    }
}

-(void) updatePosition:(ccTime) t towards:(CCSprite *)player
{
    if (_germState == kState_BeingHurt || _germState == kState_Faint) {
        return;
    }
    
    timeGap += t;
    if (self.AIModel == WAITING_MODEL && timeGap > WAITINGMODELLASTTIME) {
        self.AIModel = ATTACK_MODEL;
        timeGap = 0;
    }
    else if (self.AIModel == ATTACK_MODEL && timeGap > ATTACKLASTTIME)
    {
        self.AIModel = WAITING_MODEL;
        timeGap = 0;
    }
    
    if (self.AIModel == WAITING_MODEL) {
        [self playStandByAnimation];
    }
    else if (self.AIModel == ATTACK_MODEL)
    {
        [self playHitAnimation];
    }
}


@end
