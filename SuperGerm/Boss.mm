//
//  Boss.m
//  SuperGerm
//
//  Created by Ariequ on 14-2-14.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "Boss.h"
#import "EndGameLayer.h"
#import "ShaderManager.h"
#import "AnimateLabel.h"
#import "GamePlayScene.h"

@implementation Boss
{
    BOOL impluseAdd;
    
    int jumpCount;
    
    int direction;
    
    BOOL endPanelAdded;
}

-(id) init
{
    if ((self = [super initWithSpriteFrameName:@"Boss_1/standBy/1.png"]))
    {
        _germState = kState_NOthing;
        self.health = 150;
        _isReadyToAttack = YES;
        self.ATK = 100;
        direction = -1;
        
        WAITINGMODELLASTTIME = 3;
        FLYINGMODELLASTTIME = 3;
    }
    
    return self;
}

-(void) setupBody
{
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
    ballBodyDef.userData = self;
//    ballBodyDef.linearDamping = 10;
    _body = [WorldLayer world]->CreateBody(&ballBodyDef);
    _body->SetGravityScale(5);
    _body->SetFixedRotation(YES);
//    oringinalPositon = self.position;
    [self replaceBodyShape:_body withShapeName:@"boss"];
    [self setAwake:YES];
}

-(void) keepAwayFrom:(CCSprite *)player withMapXrange:(MapXRange) mapXRange hitType:(int)hitType
{
//    int direction = player.scaleX;
//    [self turnDirection:direction];
//    b2Vec2 impluse = [self attackImpulse:hitType];
//    _body->ApplyLinearImpulse(b2Vec2(direction*impluse.x,impluse.y), _body->GetWorldCenter());
}

-(void) playStandByAnimation
{
    if (_germState != kState_Standing) {
        _germState = kState_Standing;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        
        CCAction *_standbyAction = [actionProvider actionWithPrefix:@"Boss_1/standBy/" suffix:@".png" frame:1 frameDelay:0.05 target:self callback:@selector(standbyCallback)];
        
        [self stopAllActions];
        [self runAction:_standbyAction];
        //        [_standbyAction release];
    }
}

-(void) playJumpAnimation
{
//    if (_germState != kState_Standing) {
//        _germState = kState_Standing;
    _germState = kState_Hitting;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        
        CCAction *_standbyAction = [actionProvider actionWithPrefix:@"Boss_1/jump/" suffix:@".png" frame:1 frameDelay:0.05 target:self callback:@selector(standbyCallback)];
        
        [self stopAllActions];
        [self runAction:_standbyAction];
        //        [_standbyAction release];
//    }
}

-(void)updatePosition:(ccTime)t towards:(CCSprite *)player
{
    timeGap += t;
    if (self.AIModel == WAITING_MODEL && timeGap > WAITINGMODELLASTTIME) {
        self.AIModel = FLYING_MODEL;
        timeGap = 0;
        impluseAdd = NO;
//        flyingDirection *= -1;
    }
    else if (self.AIModel == FLYING_MODEL && timeGap > FLYINGMODELLASTTIME)
    {
        self.AIModel = WAITING_MODEL;
        timeGap = 0;
    }
    
    if (self.AIModel == WAITING_MODEL) {
        [self playStandByAnimation];
        if (jumpCount == 2) {
            direction *= -1;
            [self setScaleX:-direction];
            jumpCount = 0;
        }

        //        return;
    }
    else if (self.AIModel == FLYING_MODEL)
    {
        //        b2Vec2 myBodyPositon = _body->GetPosition();
        //        b2Vec2 targetPostion = b2Vec2(myBodyPositon.x + flyingDirection*0.1*timeGap/FLYINGMODELLASTTIME,myBodyPositon.y);// + sinf(flyingDirection*1*timeGap/FLYINGMODELLASTTIME));
        //        _body->SetTransform(targetPostion,0);
//        _body->SetLinearVelocity(b2Vec2(flyingDirection*1.5,1.5*sinf(-M_PI_2 + timeGap/FLYINGMODELLASTTIME*M_PI)));
        
        if (!impluseAdd) {
            impluseAdd = YES;
            
            _body->ApplyLinearImpulse(b2Vec2(direction*_body->GetMass()*2,_body->GetMass()*4), _body->GetWorldCenter());
            jumpCount++;
        }
        
        
//        _body->ApplyForceToCenter(b2Vec2(-10,100));
        
        b2Vec2 speed = _body->GetLinearVelocity();
        if (speed.y < 0.5 && speed.y > 0) {
            _body->ApplyLinearImpulse(b2Vec2(0,-_body->GetMass()*50), _body->GetWorldCenter());
        }
        
        [self playJumpAnimation];
    }

}

- (void)removeShader
{
    _germState = kState_NOthing;
    [[ShaderManager sharedShaderManager] enableSprite:self];
}

-(void)playHurtAnimation:(int)damage
{
//    _germState = kState_BeingHurt;
//    _damage = damage;
//    AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
//    CCAction* _hurtAction = [actionProvider actionWithName:@"germHurt/" frame:2 target:self callback:@selector(hurtAnimationCallBack)];
//    [self stopAllActions];
//    [self runAction:_hurtAction];
    
    if (_germState != kState_BeingHurt) {
        _germState = kState_BeingHurt;
        self.health -= damage;
        
        [[ShaderManager sharedShaderManager] addShaderTo:self];
        [self scheduleOnce:@selector(removeShader) delay:0.5];
        
        AnimateLabel *label = [[[AnimateLabel alloc] init] autorelease];
        [label createBMLabelSting:[NSString stringWithFormat:@"-%d", damage] pistion:ccp(SCREEN.width/2,SCREEN.height*2/3) parent:[GamePlayScene lebalLayer] withDuration:1];
        if (!endPanelAdded && self.health <= 0)
        {
            [ControlCenter player].visible = NO;
            EndGameLayer* endGameLayer = (EndGameLayer*)[CCBReader nodeGraphFromFile:@"EndUI.ccbi"];
            //        [endGameLayer setPosition:CENTER];
            [endGameLayer setScore:[[ControlCenter germManager] getScore] setKillNum:[[ControlCenter germManager] getKillNum]];
            
            [[GamePlayScene popLayer] addChild:endGameLayer];
            endPanelAdded = true;
            self.visible = NO;
            [[GamePlayScene controlLayer] setControlEnable:NO];
            //        [self unscheduleUpdate];
        }

    }
   
}


-(void) update:(ccTime)delta
{
    //    NSLog(@"germ's health %f",self.health);
    [self updatePosition:delta towards:[ControlCenter player]];
    [self dealWithPlayer:[ControlCenter player]];
    [self sythShapePosition];
}


@end
