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
        self.ATK = 1;
        direction = -1;
        self.awakeDistance = SCREEN.width/2;
        
        WAITINGMODELLASTTIME = 1;
        FLYINGMODELLASTTIME = 1;
        
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
    _body->SetGravityScale(5);
    _body->SetFixedRotation(YES);
    [self replaceBodyShape:_body withShapeName:@"boss"];
}

-(void) keepAwayFrom:(CCSprite *)player withMapXrange:(MapXRange) mapXRange hitType:(int)hitType
{
}

-(void) playStandByAnimation
{
    if (_germState != kState_Standing) {
        _germState = kState_Standing;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        
        CCAction *_standbyAction = [actionProvider actionWithPrefix:@"Boss_1/standBy/" suffix:@".png" frame:1 frameDelay:0.05 target:self callback:@selector(standbyCallback)];
        
        [self stopAllActions];
        [self runAction:_standbyAction];
    }
}

-(void) playJumpAnimation
{
    _germState = kState_Hitting;
    AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
    
    CCAction *_standbyAction = [actionProvider actionWithPrefix:@"Boss_1/jump/" suffix:@".png" frame:1 frameDelay:0.05 target:self callback:@selector(standbyCallback)];
    
    [self stopAllActions];
    [self runAction:_standbyAction];
}

-(void)updatePosition:(ccTime)t towards:(CCSprite *)player
{
    timeGap += t;
    if (self.AIModel == WAITING_MODEL && timeGap > WAITINGMODELLASTTIME) {
        self.AIModel = FLYING_MODEL;
        timeGap = 0;
        impluseAdd = NO;
    }
    else if (self.AIModel == FLYING_MODEL && timeGap > FLYINGMODELLASTTIME)
    {
        self.AIModel = WAITING_MODEL;
        timeGap = 0;
    }
    
    if (self.AIModel == WAITING_MODEL) {
        direction = -1;
        if (self.position.x < player.position.x) {
            direction = 1;
        }
        [self setScaleX:-direction];
        [self playStandByAnimation];
    }
    else if (self.AIModel == FLYING_MODEL)
    {
        if (!impluseAdd) {
            impluseAdd = YES;
            
            _body->ApplyLinearImpulse(b2Vec2(direction*_body->GetMass()*5 ,_body->GetMass()*6*5), _body->GetWorldCenter());
            jumpCount++;
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
            [endGameLayer setScore:[[ControlCenter germManager] getScore] setKillNum:[[ControlCenter germManager] getKillNum]];
            
            [[GamePlayScene popLayer] addChild:endGameLayer];
            endPanelAdded = true;
            self.visible = NO;
            [[GamePlayScene controlLayer] setControlEnable:NO];
        }
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

-(void) update:(ccTime)delta
{
    [self updatePosition:delta towards:[ControlCenter player]];
    [self dealWithPlayer:[ControlCenter player]];
    [self sythShapePosition];
}


@end
