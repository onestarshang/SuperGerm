//
//  DrippingGerm.m
//  SuperGerm
//
//  Created by Ariequ on 14-2-16.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "DripGerm.h"

@implementation DripGerm
{
    int READYATTACKLASTTIME;
    int PRODUCELASTTIME;
    int produceCount;
}

-(id) init
{
    if ((self = [super initWithSpriteFrameName:@"drip_drop/1.png"]))
    {
        _germState = kState_NOthing;
        self.health = 10;
        self.tag = 1;
        _isReadyToAttack = YES;
        self.awakeDistance = SCREEN.width/2;
        self.ATK = 20;
        self.AIModel = WAITING_MODEL;
        WAITINGMODELLASTTIME = 1;
        FLYINGMODELLASTTIME = 3;
        READYATTACKLASTTIME = 5;
        PRODUCELASTTIME = 5;
        produceCount = 0;
//        self.anchorPoint = ccp(0.5,0.5);
        
    }
    
    return self;
}

-(void) setupBody
{
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
    ballBodyDef.userData = self;
    ballBodyDef.linearDamping = 10;
    _body = [WorldLayer world]->CreateBody(&ballBodyDef);
//    _body->SetGravityScale(0);
    if (self.AIModel == WAITING_MODEL) {
        _body->SetGravityScale(0);
    }
    else
    {
        _body->SetFixedRotation(YES);
        oringinalPositon = self.position;
        [self replaceBodyShape:_body withShapeName:@"dripgerm"];
        [self setAwake:NO];
    }
}

-(void)setAwake:(BOOL) awake
{
    if (awake) {
        [self playEnterAnimation];
    }
    
    _awake = awake;
    _body->SetAwake(awake);
}



- (void)enterCallback
{
}

-(void)playEnterAnimation
{
//    AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
//    CCAction *_enterAction = [actionProvider actionWithPrefix:@"drip_drop/" suffix:@".png" frame:22 frameDelay:0.05 target:self callback:@selector(enterCallback)];
//    [self stopAllActions];
//    [self runAction:_enterAction];

}

- (void)playHurtAnimation:(int)damage
{
    _germState = kState_BeingHurt;
    _damage = damage;
    AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
    CCAction *_hurtAction = [actionProvider actionWithPrefix:@"drip_standby/" suffix:@".png" frame:3 frameDelay:0.05 target:self callback:@selector(hurtAnimationCallBack)];
    [self stopAllActions];
    [self runAction:_hurtAction];
}

-(void)standbyCallback
{
    _germState = kState_NOthing;
    [self playStandByAnimation];
}

-(void) playStandByAnimation
{
    if (_germState != kState_Standing && _germState != KState_Growing) {
        _germState = kState_Standing;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction *_standbyAction = [actionProvider actionWithPrefix:@"drip_standby/" suffix:@".png" frame:21 frameDelay:0.05 target:self callback:@selector(standbyCallback)];
        [self stopAllActions];
        [self runAction:_standbyAction];
    }
}

- (void)dripDropCallback
{
    _germState = kState_NOthing;
    [self playStandByAnimation];
}

- (void)playDripDorpAnimaion
{
    _germState = KState_Growing;
    AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
    CCAction *_dripDropAction = [actionProvider actionWithPrefix:@"drip_drop/" suffix:@".png" frame:22 frameDelay:0.05 target:self callback:@selector(dripDropCallback)];
    [self stopAllActions];
    [self runAction:_dripDropAction];
}

- (void)perHitCallback
{
    [self playHitAnimation];
}

- (void)playPreHitAnimation
{
    if (_germState != kState_Pre_Hitting && _germState != kState_Hitting) {
        _germState = kState_Pre_Hitting;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction *_preHitAction = [actionProvider actionWithPrefix:@"drip_pre_attack/" suffix:@".png" frame:3 frameDelay:0.3 target:self callback:@selector(perHitCallback)];
        [self stopAllActions];
        [self runAction:_preHitAction];
    }
}

- (void)hitCallback
{
    _germState = kState_NOthing;
    [self playHitAnimation];
}

- (void)playHitAnimation
{
    if (_germState != kState_Hitting) {
        _germState = kState_Hitting;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction *_hitAction = [actionProvider actionWithPrefix:@"drip_attack/" suffix:@".png" frame:3 frameDelay:0.1 target:self callback:@selector(hitCallback)];
        [self stopAllActions];
        [self runAction:_hitAction];
    }

}

-(void) updatePosition:(ccTime) t towards:(CCSprite *)player
{
    if (_germState == kState_BeingHurt || _germState == kState_Faint) {
        return;
    }
    
    timeGap += t;
    if (self.AIModel == WAITING_MODEL && timeGap > WAITINGMODELLASTTIME) {
        self.AIModel = PRODUCE_MODEL;
        timeGap = 0;
    }
    else if (self.AIModel == PRODUCE_MODEL && timeGap > PRODUCELASTTIME && produceCount<3)
    {
        produceCount ++;
        self.AIModel = WAITING_MODEL;
        DripGerm *drip = [[DripGerm alloc] init];
        drip.AIModel = FLYING_MODEL;
        [[GermManager sharedGermManager] addGerm:drip position:ccp(self.position.x,self.position.y-30)];
        [drip playDripDorpAnimaion];
    }
    else if (self.AIModel == FLYING_MODEL && timeGap > FLYINGMODELLASTTIME)
    {
        self.AIModel = READY_ATTACK_MODEL;
        timeGap = 0;
    }
    else if (self.AIModel == READY_ATTACK_MODEL && timeGap > READYATTACKLASTTIME)
    {
        self.AIModel = FLYING_MODEL;
        timeGap = 0;
    }
    
    if (self.AIModel == WAITING_MODEL) {
//        [self playStandByAnimation];
    }
    else if (self.AIModel == FLYING_MODEL)
    {
        [self playStandByAnimation];
        b2Vec2 speed = _body->GetLinearVelocity();
        if (speed.y > -0.5)
        {
            _body->ApplyForceToCenter(b2Vec2(_body->GetMass()*-10,0));
        }
    }
    else if (self.AIModel == READY_ATTACK_MODEL)
    {
        [self playPreHitAnimation];
    }
}

-(void)beginContactWithPlayer:(GB2Contact *)contact
{
    NSString *fixtureId = (NSString *)contact.otherFixture->GetUserData();
    NSString *myFixtureId = (NSString*)contact.ownFixture->GetUserData();
    
    if ([fixtureId  isEqualToString: @"hurtSensor"] || [fixtureId isEqualToString:@"right_normal_hit"] || [fixtureId isEqualToString:@"left_normal_hit"]) {
        _isMeetingPlayerbody = YES;
    }
     if ([myFixtureId isEqualToString:@"hurtSensor"] && [fixtureId isEqualToString:@"right_normal_hit"])
    {
        _isMeetingRightNormalHit = YES;
    }
    if ([myFixtureId isEqualToString:@"hurtSensor"] && [fixtureId isEqualToString:@"left_normal_hit"])
    {
        _isMeetingLeftNormalHit = YES;
    }
}

-(void)endContactWithPlayer:(GB2Contact *)contact
{
    NSString *fixtureId = (NSString *)contact.otherFixture->GetUserData();
    NSString *myFixtureId = (NSString*)contact.ownFixture->GetUserData();
    //    Player *player = (Player *)contact.otherFixture->GetBody()->GetUserData();
    
    if ([fixtureId  isEqualToString: @"hurtSensor"] || [fixtureId isEqualToString:@"right_normal_hit"] || [fixtureId isEqualToString:@"left_normal_hit"]) {
        _isMeetingPlayerbody = NO;
    }
    else if ([myFixtureId isEqualToString:@"hurtSensor"] && [fixtureId isEqualToString:@"right_normal_hit"])
    {
        _isMeetingRightNormalHit = NO;
    }
    else if ([myFixtureId isEqualToString:@"hurtSensor"] && [fixtureId isEqualToString:@"left_normal_hit"])
    {
        _isMeetingLeftNormalHit = NO;
    }
    
}

-(void)dealWithPlayer:(Player*)player
{
    if (_isMeetingPlayerbody && _germState == kState_Hitting) {
        [player hurtWithDamage:self.ATK AccodingToActionSprite:self withType:1];
    }
}


@end
