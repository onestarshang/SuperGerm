//
//  BulletGerm.m
//  SuperGerm
//
//  Created by Ariequ on 14-2-23.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "BulletGerm.h"
#import "Bullet.h"

@implementation BulletGerm

-(id) init
{
    if ((self = [super initWithSpriteFrameName:@"BulletGerm_Standby/1.png"]))
    {
        _germState = kState_NOthing;
        self.health = 10;
        self.tag = 1;
        _isReadyToAttack = YES;
        self.ATK = 20;
        self.awakeDistance = SCREEN.width/2;
        self.AIModel = WAITING_MODEL;
        WAITINGMODELLASTTIME = 1;
        FLYINGMODELLASTTIME = 1.5;
        _awake = NO;
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
    oringinalPositon = self.position;
    [self replaceBodyShape:_body withShapeName:@"BulletGerm"];
    [self setAwake:NO];
}


-(void) playStandByAnimation
{
    if (_germState == kState_NOthing) {
        _germState = kState_Standing;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction *_standbyAction = [actionProvider actionWithPrefix:@"BulletGerm_Standby/" suffix:@".png" frame:12 frameDelay:0.05 target:self callback:@selector(standbyCallback)];
        [self stopAllActions];
        [self runAction:_standbyAction];
    }
}

- (void)hitCallback
{
    _germState = kState_NOthing;
    Bullet *bullet = [[Bullet alloc] initWithDirection:self.scaleX];
    [self.parent addChild:bullet];
    [bullet setPosition:ccpAdd(self.position, ccp(-50*self.scaleX, 5))];
    [bullet setupBody];
}


- (void)playHitAnimation
{
    if (_germState == kState_NOthing || _germState == kState_Standing) {
        _germState = kState_Hitting;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction *_hitAction = [actionProvider actionWithPrefix:@"BulletGerm_Hit/" suffix:@".png" frame:15 frameDelay:0.05 target:self callback:@selector(hitCallback)];
        [self stopAllActions];
        [self runAction:_hitAction];
    }
}

- (void)dieAnimationCallBack
{
    [self removeFromParentAndCleanup:YES];
}

-(void)playDieAnimation:(float)damage
{
    _germState = kState_dying;
    self.health -= damage;
    AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
    CCAction *dieAction = [actionProvider actionWithPrefix:@"BulletGerm_Die/" suffix:@".png" frame:9 frameDelay:0.05 target:self callback:@selector(dieAnimationCallBack)];
    [self stopAllActions];
    [self runAction:dieAction];
}

- (void)playHurtAnimation:(int)damage
{
    _germState = kState_BeingHurt;
    _damage = damage;
    AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
    CCAction *_hurtAction = [actionProvider actionWithPrefix:@"BulletGerm_Hurt/" suffix:@".png" frame:6 frameDelay:0.05 target:self callback:@selector(hurtAnimationCallBack)];
    [self stopAllActions];
    [self runAction:_hurtAction];
}


-(void) updatePosition:(ccTime) t towards:(CCSprite *)player
{
    if (_germState == kState_BeingHurt || _germState == kState_Faint) {
        return;
    }
    
    timeGap += t;
    if (self.AIModel == WAITING_MODEL && timeGap > WAITINGMODELLASTTIME) {
        self.AIModel = FLYING_MODEL;
        timeGap = 0;
    }
    else if (self.AIModel == FLYING_MODEL && timeGap > FLYINGMODELLASTTIME)
    {
        self.AIModel = WAITING_MODEL;
        timeGap = 0;
    }
    
    if (self.AIModel == WAITING_MODEL) {
        if (self.position.x > player.position.x) {
            [self setScaleX:1];
        }
        else
        {
            [self setScaleX:-1];
        }
        [self playStandByAnimation];
    }
    else if (self.AIModel == FLYING_MODEL)
    {
        [self playHitAnimation];
    }
}



@end
