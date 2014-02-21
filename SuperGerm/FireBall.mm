//
//  FireBall.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-11.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "FireBall.h"
#import "ControlCenter.h"

@implementation FireBall
{
    CGPoint _originalPostion;
}

-(instancetype)init
{
    if (self = [super initWithSpriteFrameName:@"fireball.png"])
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
//    ballBodyDef.linearDamping = 0;
    _body = [WorldLayer world]->CreateBody(&ballBodyDef);
    _body->SetGravityScale(0);
    _originalPostion = self.position;
    [self replaceBodyShape:_body withShapeName:@"fireball"];
}


-(void)start
{
    [self scheduleUpdate];
    _body->SetLinearVelocity(b2Vec2(0,2));
    
    AnimationWapper *wapper = [[[AnimationWapper alloc] init] autorelease];
    CCAction *fireball = [wapper actionWithPrefix:@"fireballAnimaiton/" suffix:@".png" frame:4 frameDelay:0.1 target:self callback:nil];
    [self runAction:[CCRepeatForever actionWithAction:(CCActionInterval *)fireball]];
    
}

-(void)beginContactWithPlayer:(GB2Contact *)contact
{
    [[ControlCenter player] hurtWithDamage:10 AccodingToActionSprite:self withType:2];
}

-(void)update:(ccTime)delta
{
    [self sythShapePosition];
    if (self.position.y - _originalPostion.y > 300) {
        _body->SetLinearVelocity(b2Vec2(0,-2));
        self.flipY = YES;
    }
    else if (self.position.y - _originalPostion.y < -50)
    {
        _body->SetLinearVelocity(b2Vec2(0,2));
        self.flipY = NO;
    }
}

-(void)stop
{
    [self unscheduleUpdate];
}

@end
