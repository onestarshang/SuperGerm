//
//  MoveingPlatform.m
//  SuperGerm
//
//  Created by Ariequ on 14-2-22.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "MovingPlatform.h"
#import "ControlCenter.h"

@implementation MovingPlatform
{
    CGPoint _originalPostion;
    int direction;
}

-(instancetype)init
{
    if (self = [super initWithSpriteFrameName:@"movingplatform.png"])
    {
        direction = 1;
    }
    return self;
}

-(void) setupBody
{
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_kinematicBody;
    ballBodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
    ballBodyDef.userData = self;
    //    ballBodyDef.linearDamping = 0;
    _body = [WorldLayer world]->CreateBody(&ballBodyDef);
    _body->SetGravityScale(0);
    _originalPostion = self.position;
    [self replaceBodyShape:_body withShapeName:@"MovingPlatform"];
}


-(void)start
{
    [self scheduleUpdate];
}

-(void)update:(ccTime)delta
{
    [self sythShapePosition];
    if (self.position.x - _originalPostion.x > 300) {
        direction = -1;
    }
    else if (self.position.x - _originalPostion.x < 0)
    {
        direction = 1;
    }
    
//     _body->SetTransform(b2Vec2(self.position.x/PTM_RATIO + direction*0.1,self.position.y/PTM_RATIO), 0);
    _body->SetLinearVelocity(b2Vec2(direction*2,0));

}

-(void) beginContactWithPlayer:(GB2Contact*)contact
{
    NSString *otherFixtureId = (NSString *)contact.otherFixture->GetUserData();
    
    if ([otherFixtureId isEqualToString:@"player_body"]) {
        [ControlCenter player].contactFloorCount++;
    }
}

-(void) endContactWithPlayer:(GB2Contact*)contact
{
    NSString *otherFixtureId = (NSString *)contact.otherFixture->GetUserData();
    
    if ([otherFixtureId isEqualToString:@"player_body"]) {
        [ControlCenter player].contactFloorCount--;
    }
}


-(void)stop
{
    [self unscheduleUpdate];
}

@end
