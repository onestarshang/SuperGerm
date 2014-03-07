//
//  Bullet.m
//  SuperGerm
//
//  Created by Ariequ on 14-2-23.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "Bullet.h"
#import "WorldLayer.h"

@implementation Bullet
{
    int _direction;
    float ATK;
    CGPoint _oringinalPostion;
}

- (instancetype)initWithDirection:(int)direction
{
    self = [super initWithSpriteFrameName:@"BulletGerm_Bullet.png"];
    _direction = direction;
    ATK = 0.5;
    [self scheduleUpdate];
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
    [self replaceBodyShape:_body withShapeName:@"Bullet"];
    _oringinalPostion = self.position;
}


- (void)update:(ccTime)delta
{
    if (fabsf(self.position.x - _oringinalPostion.x) > SCREEN.width) {
        [self removeFromParentAndCleanup:YES];
        [WorldLayer world]->DestroyBody(_body);
    }
    else{
        [self sythShapePosition];
        _body->SetLinearVelocity(b2Vec2(-_direction*2,0));
    }
}
-(void)beginContactWithPlayer:(GB2Contact *)contact
{
    NSString *fixtureId = (NSString *)contact.otherFixture->GetUserData();
    
    if ([fixtureId  isEqualToString: @"hurtSensor"]) {
        [[ControlCenter player] hurtWithDamage:ATK AccodingToActionSprite:self withType:1];
        [self addHitEffect];
    }
}

- (void)hitEffectCallBack
{
    [self removeFromParentAndCleanup:YES];
    [WorldLayer world]->DestroyBody(_body);
}

-(void)addHitEffect
{
    AnimationWapper* hitEffectProvider = [[[AnimationWapper alloc] init] autorelease];
    CCAction* _hitAction = [hitEffectProvider actionWithPrefix:@"BulletGerm_Hiteffect/" suffix:@".png" frame:3 target:self callback:@selector(hitEffectCallBack)];
    [self runAction:_hitAction];
}


@end
