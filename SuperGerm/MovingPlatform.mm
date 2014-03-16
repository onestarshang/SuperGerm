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
    int directionX;
    int directionY;
    float _waitingTime;
    int _offsetX;
    int _offsetY;
    float _speed;
    BOOL _passengerOn;
}

-(instancetype)init
{
    if (self = [super initWithSpriteFrameName:@"movingplatform.png"])
    {
        directionX = 1;
        directionY = 1;
        _waitingTime = 0;
        _offsetX = 200;
        _offsetY = 0;
        _speed = 2;
        _passengerOn = NO;
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

- (void)setProperties:(NSDictionary *)properties
{
    if ([properties objectForKey:@"waitingTime"]) {
        _waitingTime = [properties[@"waitingTime"] floatValue];
    }
    
    if ([properties objectForKey:@"offsetX"]) {
        _offsetX = [properties[@"offsetX"] integerValue];
    }
    
    if ([properties objectForKey:@"offsetY"]) {
        _offsetY = [properties[@"offsetY"] integerValue];
    }
    
    if ([properties objectForKey:@"speed"]) {
        _speed = [properties[@"speed"] floatValue];
    }

}

- (void)setCustomProperties:(NSDictionary *)customProperties
{
    if ([customProperties objectForKey:@"waitingTime"]) {
        _waitingTime = [customProperties[@"waitingTime"] floatValue];
    }
    
    if ([customProperties objectForKey:@"offsetX"]) {
        _offsetX = [customProperties[@"offsetX"] integerValue];
    }
    
    if ([customProperties objectForKey:@"offsetY"]) {
        _offsetY = [customProperties[@"offsetY"] integerValue];
    }
    
    if ([customProperties objectForKey:@"speed"]) {
        _speed = [customProperties[@"speed"] floatValue];
    }
}

- (void)realStart
{
    [self scheduleUpdate];
}

-(void)start
{
    [self scheduleOnce:@selector(realStart) delay:_waitingTime];
}

-(void)update:(ccTime)delta
{
    [self sythShapePosition];
    
    if (_offsetX == 0) {
        directionX = 0;
    }
    else if (self.position.x - _originalPostion.x > _offsetX) {
        directionX = -1;
    }
    else if (self.position.x - _originalPostion.x < 0)
    {
        directionX = 1;
    }
    
    if (_offsetY == 0) {
        directionY = 0;
    }
    else if (self.position.y - _originalPostion.y > _offsetY) {
        directionY = -1;
    }
    else if (self.position.y - _originalPostion.y < 0)
    {
        directionY = 1;
    }
    

    
    if (_passengerOn) {
        [ControlCenter player].absoluteSpeed = ccp(_speed*directionX,_speed*directionY);
    }
    _body->SetLinearVelocity(b2Vec2(directionX*_speed,directionY*_speed));

}

-(void) beginContactWithPlayer:(GB2Contact*)contact
{
    NSString *otherFixtureId = (NSString *)contact.otherFixture->GetUserData();
//    b2Vec2 speed =contact.otherFixture->GetBody()->GetLinearVelocity();
    
    if ([otherFixtureId isEqualToString:@"player_body"]) {
        [ControlCenter player].contactFloorCount++;
        _passengerOn = YES;
    }
}

-(void) endContactWithPlayer:(GB2Contact*)contact
{
    NSString *otherFixtureId = (NSString *)contact.otherFixture->GetUserData();
    
    if ([otherFixtureId isEqualToString:@"player_body"] && [ControlCenter player].contactFloorCount>0) {
        [ControlCenter player].contactFloorCount--;
        _passengerOn = NO;
        [ControlCenter player].absoluteSpeed = ccp(0,0);
    }
}


- (void)presolveContactWithPlayer:(GB2Contact *)contact
{
    b2Vec2 speed =contact.otherFixture->GetBody()->GetLinearVelocity();
    
    if (speed.y > 0.1) {
        [contact setEnabled:NO];
    }
}

-(void)stop
{
    [self unscheduleUpdate];
}

@end
