//
//  Germ.m
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-15.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "Germ.h"
#import "GamePlayScene.h"


@implementation Germ
{
    CCSprite *playAnimation;
    b2Vec2 desireVelocity;
    CGPoint desirePostion;
    
    b2Vec2 desireOffset;
    
    int flyingDirection;
}

-(id) init
{
    if ((self = [super initWithSpriteFrameName:@"germ_standby/0000"]))
    {
        _germState = kState_NOthing;
        self.health = 10;
        self.tag = 1;
        _isReadyToAttack = YES;
        self.ATK = 0.5;
        self.awakeDistance = SCREEN.width/2;
        self.AIModel = WAITING_MODEL;
        flyingDirection = 1;
        WAITINGMODELLASTTIME = 1;
        FLYINGMODELLASTTIME = 3;
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
    ballBodyDef.linearDamping = 10;
    _body = [WorldLayer world]->CreateBody(&ballBodyDef);
    _body->SetGravityScale(0);
    oringinalPositon = self.position;
    [self replaceBodyShape:_body withShapeName:@"germ"];
    [self setAwake:NO];
}

-(void)setAwake:(BOOL) awake
{
    if (awake) {
        [self playEnterAnimation];
    }
    
    _awake = awake;
    _body->SetAwake(awake);
}

-(BOOL)isAwake
{
    return _awake;
}

-(void)enterCallback
{
    
}

-(void)playEnterAnimation
{
    [self playStandByAnimation];
}

-(void)standbyCallback
{
    _germState = kState_NOthing;
    [self playStandByAnimation];
}

-(void) playStandByAnimation
{
    if (_germState != kState_Standing) {
        _germState = kState_Standing;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction* _standbyAction = [actionProvider actionWithName:@"germ_standby/" frame:32 target:self callback:@selector(standbyCallback)];
        [self stopAllActions];
        [self runAction:_standbyAction];
//        [_standbyAction release];
    }
}

-(void)hitCallback
{
    _germState = kState_NOthing;
    [self playStandByAnimation];
}

-(void)afraidCallback
{
    
}

-(void) playAfraidAnimation
{
}


-(void)playDieAnimation:(float)damage
{
    self.health -= damage;
    [self removeFromParentAndCleanup:YES];
}

-(void)hurtAnimationCallBack
{
    _germState = kState_NOthing;
    
    if (self.health - _damage <= 0) {
        [self playDieAnimation:_damage];
    }
    else
    {
        [self playStandByAnimation];
        self.health -= _damage;
    }
}

-(void) playHitAnimation
{
    if (_germState != kState_Hitting) {
        _germState = kState_Hitting;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction* _hitAction = [actionProvider actionWithName:@"germHit/" frame:28 target:self callback:@selector(hitCallback)];
        [self stopAllActions];
        [self runAction:_hitAction];
    }
//    [_hitAction release];
}

-(void)playHurtAnimation:(int)damage
{
    _germState = kState_BeingHurt;
    _damage = damage;
    AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
   CCAction* _hurtAction = [actionProvider actionWithName:@"germHurt/" frame:2 target:self callback:@selector(hurtAnimationCallBack)];
    [self stopAllActions];
    [self runAction:_hurtAction];
//    [_hurtAction release];
}

static const float scaleFactor = 1;
-(void) updatePosition:(ccTime) t towards:(CCSprite *)player
{
    if (_germState == kState_BeingHurt || _germState == kState_Faint) {
        return;
    }
    
    timeGap += t;
    if (_AIModel == WAITING_MODEL && timeGap > WAITINGMODELLASTTIME) {
        _AIModel = FLYING_MODEL;
        timeGap = 0;
        flyingDirection *= -1;
    }
    else if (_AIModel == FLYING_MODEL && timeGap > FLYINGMODELLASTTIME)
    {
        _AIModel = WAITING_MODEL;
        timeGap = 0;
    }
    
    if (_AIModel == WAITING_MODEL) {
        [self playStandByAnimation];
    }
    else if (_AIModel == FLYING_MODEL)
    {
        _body->SetLinearVelocity(b2Vec2(flyingDirection*1.5,1.5*sinf(-M_PI_2 + timeGap/FLYINGMODELLASTTIME*M_PI)));
        [self playHitAnimation];
    }
    
    if (self.position.x > player.position.x) {
        [self setScaleX:1];
    }
    else
    {
        [self setScaleX:-1];
    }
}

-(b2Vec2)attackImpulse:(int)hitType
{
    int direction = [ControlCenter player].scaleX;
    switch (hitType) {
        case 0:
            return b2Vec2(_body->GetMass()*5*direction,0);
            break;
        case 1:
            return b2Vec2(_body->GetMass()*5*direction,_body->GetMass()*2);
            break;
        case 2:
            return b2Vec2(_body->GetMass()*5*direction,20);
            break;
        case 3:
            return b2Vec2(_body->GetMass()*5*direction,-20);
            break;
        default:
            break;
    }
    return b2Vec2(0,0);
}

-(void) keepAwayFrom:(CCSprite *)player withMapXrange:(MapXRange) mapXRange hitType:(int)hitType
{
    int direction = player.scaleX;
    [self turnDirection:direction];
    b2Vec2 impluse = [self attackImpulse:hitType];
    _body->ApplyLinearImpulse(b2Vec2(direction*impluse.x,impluse.y), _body->GetWorldCenter());
}

-(void)turnDirection:(int)direction
{
    _direction = direction;
    [self setScaleX:-direction];
}


-(void)hurtWithDamage:(int)damage
{
    if (_germState != kState_BeingHurt) {
        [self playHurtAnimation:damage];
    }
}

-(void)die
{
    [self removeFromParent];
}

-(void) update:(ccTime)delta
{
//    NSLog(@"germ's health %f",self.health);
    [self updatePosition:delta towards:[ControlCenter player]];
    [self dealWithPlayer:[ControlCenter player]];
    [self sythShapePosition];
}

-(void) sythShapePosition
{
    b2Vec2 bodyPostion = _body->GetPosition();
    self.position = ccp(bodyPostion.x*PTM_RATIO,bodyPostion.y*PTM_RATIO);
}


-(void) beginContactWithGerm:(GB2Contact*)contact
{
    
}

-(void)beginContactWithPlayer:(GB2Contact *)contact
{
    NSString *fixtureId = (NSString *)contact.otherFixture->GetUserData();
    NSString *myFixtureId = (NSString*)contact.ownFixture->GetUserData();
    
//    Player *player = (Player *)contact.otherFixture->GetBody()->GetUserData();
    
//    if (![myFixtureId isEqualToString:@"germ"]) {
//        return;
//    }
    
    if ([fixtureId  isEqualToString: @"hurtSensor"]) {
        _isMeetingPlayerbody = YES;
    }
    else if ([myFixtureId isEqualToString:@"hurtSensor"] && [fixtureId isEqualToString:@"right_normal_hit"])
    {
        _isMeetingRightNormalHit = YES;
    }
    else if ([myFixtureId isEqualToString:@"hurtSensor"] && [fixtureId isEqualToString:@"left_normal_hit"])
    {
        _isMeetingLeftNormalHit = YES;
    }
//    else if ([myFixtureId isEqualToString:@"hurtSensor"] && [fixtureId isEqualToString:@"right_combo_hit"] || [fixtureId isEqualToString:@"left_combo_hit"])
//    {
//        _isMeetingComboHit = YES;
//    }
}

-(void)endContactWithPlayer:(GB2Contact *)contact
{
    NSString *fixtureId = (NSString *)contact.otherFixture->GetUserData();
    NSString *myFixtureId = (NSString*)contact.ownFixture->GetUserData();
//    Player *player = (Player *)contact.otherFixture->GetBody()->GetUserData();
   
    if ([fixtureId  isEqualToString: @"hurtSensor"]) {
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

-(void)setReadyToAttack
{
    _isReadyToAttack = YES;
}

-(int)germState
{
    return _germState;
}

-(b2Body*)body
{
    return _body;
}

-(BOOL)isMeetingNormalHit
{
    return _isMeetingNormalHit;
}
-(BOOL)isMeetingComboHit
{
    return _isMeetingComboHit;
}

-(void)dealWithPlayer:(Player*)player
{
    if (_isReadyToAttack && _isMeetingPlayerbody && _germState == kState_Hitting) {
        _isReadyToAttack = NO;
        [player hurtWithDamage:self.ATK AccodingToActionSprite:self withType:1];
        [self playHitAnimation];
        [self scheduleOnce:@selector(setReadyToAttack) delay:5];
    }
}

-(void)resetFaint
{
    _germState = kState_NOthing;
    [self playStandByAnimation];
}

-(void)dealWithBigAttack
{
    _germState = kState_Faint;
    _body->SetLinearVelocity(b2Vec2(0,0));
    _body->ApplyLinearImpulse(b2Vec2(0,-1000), _body->GetWorldCenter());
    [self stopAllActions];
    [self scheduleOnce:@selector(resetFaint) delay:5];
}

-(void)setActive:(BOOL)isActive
{
    _body->SetActive(isActive);
}

- (BOOL)isInScreen
{
    CGPoint worldPoint = [self.parent convertToWorldSpace:self.position];
    BOOL xIn = worldPoint.x > 0 && worldPoint.x < SCREEN.width;
    BOOL yIn = worldPoint.y > 0 && worldPoint.y < SCREEN.height;
    return xIn && yIn;
}
@end
