//
//  Rock.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-12.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "Rock.h"

@implementation Rock
{
    BOOL _impuliseAdded;
    CCSprite *dust;
}
-(instancetype)init
{
    if (self = [super initWithSpriteFrameName:@"rock.png"])
    {
        _impuliseAdded = NO;
//        [self addDustBlowEffect];

    }
    return self;
}

-(void)start
{
    [self scheduleUpdate];
    _body->SetAwake(YES);
}

-(void)update:(ccTime)delta
{
    [self sythShapePosition];
//    b2Vec2 currentVelocity = _body->GetLinearVelocity();
//    if (currentVelocity.x > -1 && currentVelocity.x < 0) {
//        _body->SetAwake(NO);
//        _body->SetAngularVelocity(0);
//        _body->SetLinearVelocity(b2Vec2(0,0));
//        [self unscheduleUpdate];
//    }
}

-(void) setupBody
{
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
    ballBodyDef.userData = self;
    //    ballBodyDef.linearDamping = 0;
    _body = [WorldLayer world]->CreateBody(&ballBodyDef);
    _body->SetFixedRotation(NO);
//    _body->SetGravityScale(0);
    [self replaceBodyShape:_body withShapeName:@"rock"];
    _body->SetAwake(NO);
}

-(void)beginContactWithPlayer:(GB2Contact *)contact
{
//    [[ControlCenter player] meetFireBall];
    NSString *fixtureId = (NSString *)contact.otherFixture->GetUserData();
    if ([fixtureId isEqualToString:@"hurtSensor"]) {
        [[ControlCenter player] hurtWithDamage:20 AccodingToActionSprite:self withType:3];
        
        b2Fixture * myfixture = contact.ownFixture;
        //get the existing filter
        b2Filter filter = myfixture->GetFilterData();
        //change whatever you need to, eg.
        filter.groupIndex = -1;
        //and set it back
        myfixture->SetFilterData(filter);
        
        [self scheduleOnce:@selector(resetFixtureGroupIndex) delay:3];
    }
}

- (void)resetFixtureGroupIndex
{
    
    b2Fixture * myfixture = _body->GetFixtureList();
    //get the existing filter
    b2Filter filter = myfixture->GetFilterData();
    //change whatever you need to, eg.
    filter.groupIndex = 0;
    //and set it back
    myfixture->SetFilterData(filter);

}

-(void)beginContactWithMapElement:(GB2Contact *)contact
{
    if (!_impuliseAdded) {
        _impuliseAdded = YES;
        _body->ApplyLinearImpulse(b2Vec2(_body->GetMass()*-5,0), _body->GetWorldCenter());
        [self addDustBlowEffect];
    }

}

- (void)dustBlowEffectCallBack
{
    [dust removeFromParentAndCleanup:YES];
}

- (void)addDustBlowEffect
{
    dust = [CCSprite spriteWithSpriteFrameName:@"dustflow/1.png"];
    [self addChild:dust];
    AnimationWapper* hitEffectProvider = [[[AnimationWapper alloc] init] autorelease];
    CCAction* _hitAction = [hitEffectProvider actionWithPrefix:@"dustflow/" suffix:@".png" frame:9  frameDelay:0.03 target:self callback:@selector(dustBlowEffectCallBack)];
    [dust runAction:_hitAction];
//    [dust setPosition:ccpAdd(germ.position, ccp(-self.scaleX*20, 0))];
}



@end
