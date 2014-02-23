
//
//  LandGerm.m
//  SuperGerm
//
//  Created by Ariequ on 13-12-26.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "LandGerm.h"

@implementation LandGerm

-(id) init
{
    if ((self = [super initWithSpriteFrameName:@"enemy2/anim_walk_0000"]))
    {
        _germState = kState_NOthing;
        self.health = 10;
        self.awakeDistance = SCREEN.width/2;
        self.tag = 1;
        _isReadyToAttack = YES;
        _direction = 1;
        self.ATK = 30;
        [self setAnchorPoint:ccp(0.3, 0.27)];
        WAITINGMODELLASTTIME = 2;
        FLYINGMODELLASTTIME = 2;
        self.AIModel = WAITING_MODEL;
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
    _body->SetFixedRotation(YES);
    [self replaceBodyShape:_body withShapeName:@"landgerm"];
    [self setAwake:NO];
}

-(void)enterCallback
{
    _germState = kState_NOthing;
    [self playStandByAnimation];
}

-(void)playEnterAnimation
{
    AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
    CCAction* _enterAnimation = [actionProvider actionWithName:@"enemy2/anim_thrown_" frame:21 target:self callback:@selector(enterCallback)];
    [self stopAllActions];
    [self runAction:_enterAnimation];
}

-(void)standbyCallback
{
    _germState = kState_NOthing;
    [self playStandByAnimation];
}

//-(void) keepAwayFrom:(CCSprite *)player withMapXrange:(MapXRange) mapXRange hitType:(int)hitType
//{
//    int direction = player.scaleX;
//    _body->ApplyForceToCenter(b2Vec2(direction*100,0));
//}



-(void) playStandByAnimation
{
    if (_germState == kState_NOthing) {
        _germState = kState_Standing;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
       CCAction* _standbyAction = [actionProvider actionWithName:@"enemy2/anim_walk_" frame:15 target:self callback:@selector(standbyCallback)];
        [self stopAllActions];
        [self runAction:_standbyAction];
    }
}

-(void)playHurtAnimation:(int)damage
{
//    _germState = kState_BeingHurt;
//    _hurtAction = [[AnimationWapper alloc] actionWithName:@"enemy2/anim_walk_" frame:15 target:self callback:@selector(hurtAnimationCallBack:damage:)];
//    [self stopAllActions];
//    [self runAction:_hurtAction];
    _damage = damage;
    self.health -= damage;
    [super hurtAnimationCallBack];
}


-(void) playHitAnimation
{
    if (_germState != kState_Hitting) {
        _germState = kState_Hitting;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction* _hitAction = [actionProvider actionWithName:@"enemy2/anim_eat_" frame:26 target:self callback:@selector(hitCallback)];
        [self stopAllActions];
        [self runAction:_hitAction];

    }
}

-(void)dieAnimationCallback
{
    [self removeFromParentAndCleanup:YES];
}

-(void)playDieAnimation:(float)damage
{
    self.health = 0;
    AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
    CCAction* _dieAction = [actionProvider actionWithName:@"enemy2/anim_death_" frame:21 target:self callback:@selector(dieAnimationCallback)];
    [self stopAllActions];
    [self runAction:_dieAction];
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
        [self playStandByAnimation];
        _body->ApplyForceToCenter(b2Vec2(-_direction*10,0));
        //        return;
    }
    else if (self.AIModel == FLYING_MODEL)
    {
        [self playHitAnimation];
    }
    
     
}

//-(void) update:(ccTime)delta
//{
////    _body->ApplyForceToCenter(b2Vec2(0,-_body->GetMass()*[WorldLayer world]->GetGravity().y));
//    [self sythShapePosition];
////    //    if (self.health <= 0) {
////    //        [self dead];
////    //    }
//}

-(void)turnDirection:(int)direction
{
    _direction = direction;
    [self setScaleX:direction];
}

-(void) beginContactWithMapElement:(GB2Contact*)contact
{
    NSString *myfixtureId = (NSString *)contact.ownFixture->GetUserData();
    NSString *otherfixtureId = (NSString *)contact.otherFixture->GetUserData();
    
    if (([myfixtureId isEqualToString:@"left_down_Sensor"] && [otherfixtureId isEqualToString:@"megma"])
        || ([myfixtureId isEqualToString:@"left_Sensor"] && [otherfixtureId isEqualToString:@"floor"]))
    {
        [self turnDirection:-1];
    }
    else if (([myfixtureId isEqualToString:@"right_down_Sensor"] && [otherfixtureId isEqualToString:@"megma"])
             || ([myfixtureId isEqualToString:@"right_Sensor"] && [otherfixtureId isEqualToString:@"floor"]))
    {
        [self turnDirection:1];
    }
    
    if ([myfixtureId isEqualToString:@"germ"] && [otherfixtureId isEqualToString:@"megma"]) {
        [self playDieAnimation:1000];
    }
}

-(void) endContactWithMapElement:(GB2Contact*)contact
{
    NSString *myfixtureId = (NSString *)contact.ownFixture->GetUserData();
    NSString *otherfixtureId = (NSString *)contact.otherFixture->GetUserData();

//    if ([myfixtureId isEqualToString:@"left_down_Sensor"] && [otherfixtureId isEqualToString:@"floor"])
//    {
//        [self turnDirection:-1];
//    }
//    else if ([myfixtureId isEqualToString:@"right_down_Sensor"] && [otherfixtureId isEqualToString:@"floor"])
//    {
//        [self turnDirection:1];
//    }

}

-(void) beginContactWithMapManager:(GB2Contact*)contact
{
    NSString *myfixtureId = (NSString *)contact.ownFixture->GetUserData();
    NSString *otherfixtureId = (NSString *)contact.otherFixture->GetUserData();
    
    if ([myfixtureId isEqualToString:@"left_Sensor"] && [otherfixtureId isEqualToString:@"wall"])
        
    {
        [self turnDirection:-1];
    }
    else if ([myfixtureId isEqualToString:@"right_Sensor"] && [otherfixtureId isEqualToString:@"wall"])
    {
        [self turnDirection:1];
    }
}


@end
