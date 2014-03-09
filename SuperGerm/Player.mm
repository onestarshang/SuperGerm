//
//  Player.m
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-10.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "Player.h"
#import "AnimationWapper.h"
#import "WorldLayer.h"
#import "Define.h"
#import "AnimateLabel.h"
#import "SimpleAudioEngine.h"
#import "ControlCenter.h"
#import "GamePlayScene.h"
#import "ShaderManager.h"

const int SPEED = 6;

@implementation Player
{
    b2Body *_body;
    int desireDirection;
    BOOL hitGerm;
    CCSprite* showAnimationBase;
    BOOL isPlayingHitEffctAudio;
    BOOL _invincible;
    int _currentAttacType;
    float _lastAttackTime;
    BOOL _showingHitEffect;
    int _currentAttacHurt;
    int hit0count;
    int hit1count;
    int hit2count;
    int hit3count;
    int hit4count;
    int hurt3count;
    
    /**
     * This is the rate at which the hero speeds up when you move him left and right.
     */
    float acceleration;//:Number = 1;
    
    /**
     * This is the fastest speed that the hero can move left or right.
     */
    float maxVelocity;//:Number = 8;
    
    /**
     * This is the initial velocity that the hero will move at when he jumps.
     */
    float jumpHeight;//:Number = 11;
    
    /**
     * This is the amount of "float" that the hero has when the player holds the jump button while jumping.
     */
    float jumpAcceleration;//:Number = 0.3;

}

-(id) init
{
    if ((self = [super initWithSpriteFrameName:@"standby/1.png"]))
    {
//        [self setAnchorPoint:ccp(0.3,0.2)];
        _playerState = kState_NOthing;
        
        self.health = 3;
        self.totalHealth = 3;
    
        self.tag = 0;
        _invincible = YES;
        self.opacity = 125;
        [self scheduleOnce:@selector(resetInvincible) delay:4];
        _combo = 0;
        
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.userData = self;
//        ballBodyDef.linearDamping = 5;
        _body = [WorldLayer world]->CreateBody(&ballBodyDef);
        _body->SetFixedRotation(YES);
        _body->SetGravityScale(2);
        
        desireDirection = 1;
        
        _lastAttackTime = clock();
        
//        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        
        self.hitEffect = [CCSprite spriteWithSpriteFrameName:@"hitEffect/01_01.png"];
        
        [self replaceBodyShape:_body withShapeName:@"standby"];
        
        acceleration = 1;
        maxVelocity = 6;
        jumpHeight = 13;
        jumpAcceleration = 0.3;
        
        
    }
    
    return self;
    
}

- (void)addShader
{
    [[ShaderManager sharedShaderManager] addShaderTo:self];
}

- (void)removeShader
{
    [[ShaderManager sharedShaderManager] removeShader];
//    [self setOpacity:125];
//    NSLog(@"my opacity %hhu", self.opacity);
}


-(void) standByCallBack
{
    _playerState = kState_NOthing;
    [self playStandbyAnimation];
}

-(void) beHurtCallBack
{
    _playerState = kState_NOthing;
    [self replaceBodyShape:_body withShapeName:@"standby"];
    [self playStandbyAnimation];
}

-(void)resetInvincible
{
    _invincible = NO;
    [self setOpacity:255];
}

- (void)replaceHurtPhysics
{
    [self replaceBodyShape:_body withShapeName:@"hurt3"];
}

- (void)hurt3Update
{
    hurt3count++;
    if (hurt3count == 2) {
        _body->ApplyLinearImpulse(b2Vec2(-self.scaleX*_body->GetMass()*5,0), _body->GetWorldCenter());
    }
    else if (hurt3count == 26) {
        hurt3count = 0;
        [self beHurtCallBack];
    }

}

-(void)playHurtAnimation:(int)type
{
    _playerState = kState_BeingHurt;
    
    CCAction *hurtAction;
    
    float animationInterval = 0.03;
    
    AnimationWapper *wapper = [[[AnimationWapper alloc] init] autorelease];
    
    switch (type) {
        case 1:
            hurtAction = [wapper actionWithPrefix:@"hurt1/" suffix:@".png" frame:7 frameDelay:animationInterval target:self callback:@selector(beHurtCallBack)];
            break;
        case 2:
            hurtAction = [wapper actionWithPrefix:@"hurt2/" suffix:@".png" frame:7  frameDelay:animationInterval target:self callback:@selector(beHurtCallBack)];
            break;
        case 3:
            hurtAction = [wapper actionWithPrefix:@"hurt3/" suffix:@".png" frame:26 frameDelay:animationInterval target:self callback:nil];
            [self scheduleOnce:@selector(replaceHurtPhysics) delay:0.1];
            [self schedule:@selector(hurt3Update) interval:animationInterval repeat:25 delay:0];
        default:
            break;
    }
    
    [self stopAllActions];
    [self runAction:hurtAction];
//    [hurtAction release];
    [self setOpacity:125];
    _invincible = YES;
    [self addShader];
    [self scheduleOnce:@selector(removeShader) delay:0.5];
    [self scheduleOnce:@selector(resetInvincible) delay:4];
}

-(void) playStandbyAnimation
{
    if ((_playerState == kState_NOthing || _playerState == kState_Running)) {
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction* _standbyAction = [actionProvider actionWithPrefix:@"standby/" suffix:@".png" frame:8 target:self callback:@selector(standByCallBack)];
        _playerState = kState_Standing;

        [self stopAllActions];
        [self runAction:_standbyAction];
//        [_standbyAction release];
    }
}

-(void)jumpCallBack
{
    _playerState = kState_NOthing;
    [self replaceBodyShape:_body withShapeName:@"standby"];
    [self playStandbyAnimation];
}

-(void) playBigJumpAnimaiton
{
    if ((_playerState == kState_Jumping || _playerState == kState_Running || _playerState == kState_Standing)) {
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
         CCAction* _jump = [actionProvider actionWithPrefix:@"bigjump/" suffix:@".png" frame:16 target:self callback:@selector(jumpCallBack)];
        _playerState = kState_Jumping;
        
        [self stopAllActions];
        [self runAction:_jump];
    }

}

-(void) playSmallJumpAnimaiton
{
    if ((_playerState == kState_NOthing || _playerState == kState_Running || _playerState == kState_Standing)) {
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction* _jump = [actionProvider actionWithPrefix:@"smalljump/" suffix:@".png" frame:10 target:self callback:@selector(jumpCallBack)];
        _playerState = kState_Jumping;
        
        [self stopAllActions];
        [self runAction:_jump];
    }
    
}


-(void)moveAnimationCallBack
{
    _playerState = kState_NOthing;
    [self playStandbyAnimation];
}

-(void) playRunAnimation
{
    if (_playerState == kState_Standing || _playerState == kState_NOthing) {
        _playerState = kState_Running;
        AnimationWapper *actionProvider = [[[AnimationWapper alloc] init] autorelease];
        CCAction* _moveAction = [actionProvider actionWithPrefix:@"walk/" suffix:@".png" frame:20 target:self callback:@selector(moveAnimationCallBack)];
        [self stopAllActions];
        [self runAction:_moveAction];
    }
}

-(void)reSetCombo
{
    if (_playerState != kState_Hitting) {
        _combo = 0;
//        _currentAttacType = 0;
    }
}

-(void) hitAnimationCallback
{
    if (!hitGerm) {
        _combo = 0;
        _currentAttacType = 0;
    }
    else
    {
        _currentAttacType ++;
    }
    
    _playerState = kState_NOthing;
    hitGerm = NO;
    isPlayingHitEffctAudio = NO;
    [self replaceBodyShape:_body withShapeName:@"standby"];
    [self playStandbyAnimation];
    [self scheduleOnce:@selector(reSetCombo) delay:3];
}

- (void)hit0Update
{
    hit0count++;
    if (hit0count == 3) {
        _playerState = kState_Hitting;
        hitGerm = NO;
        isPlayingHitEffctAudio = NO;
        _currentAttacHurt = 10;
        [self attactEnemies];
    }
    else if (hit0count == 7) {
        hit0count = 0;
        [self hitAnimationCallback];
    }
}

- (void)hit1Update
{
    hit1count++;
    
    if (hit1count == 2) {
        _playerState = kState_Hitting;
        hitGerm = NO;
        isPlayingHitEffctAudio = NO;
        _currentAttacHurt = 10;

        [self attactEnemies];
    }
    else if (hit1count == 7)
    {
        _playerState = kState_Hitting;
        hitGerm = NO;
        isPlayingHitEffctAudio = NO;
        _currentAttacHurt = 10;
        [self attactEnemies];
    }
    else if (hit1count == 9) {
        hit1count = 0;
        [self hitAnimationCallback];
    }
//    _body->ApplyForceToCenter(b2Vec2(_body->GetMass()*20*self.scaleX,0));
}

- (void)hit2Update
{
    hit0count++;
    if (hit0count == 10) {
        _playerState = kState_Hitting;
        hitGerm = NO;
        isPlayingHitEffctAudio = NO;
        _currentAttacHurt = 30;
        [self attactEnemies];
    }
    else if (hit0count == 16) {
        [self hitAnimationCallback];
        hit0count = 0;
    }
}

- (void)hit3Update
{
    hit3count++;
    
    if (hit3count == 8) {
        [self attactEnemies];
    }
    else if (hit3count == 15)
    {
        _playerState = kState_Hitting;
        hitGerm = NO;
        isPlayingHitEffctAudio = NO;
        _currentAttacHurt = 10;
        [self attactEnemies];

    }
    else if (hit3count == 22)
    {
        _playerState = kState_Hitting;
        hitGerm = NO;
        isPlayingHitEffctAudio = NO;
        _currentAttacHurt = 10;
        [self attactEnemies];
    }
    else if (hit3count == 23) {
        hit3count = 0;
        [self hitAnimationCallback];
    }
    
    _body->ApplyForceToCenter(b2Vec2(150,_body->GetMass()*120));
}

- (void)hit4Update
{
    hit4count++;
    
    if (hit4count == 6) {
        [self attactEnemies];
    }
    else if (hit4count == 11)
    {
        _playerState = kState_Hitting;
        hitGerm = NO;
        isPlayingHitEffctAudio = NO;
        _currentAttacHurt = 10;
        [self attactEnemies];
        
    }
    else if (hit4count == 19)
    {
        _playerState = kState_Hitting;
        hitGerm = NO;
        isPlayingHitEffctAudio = NO;
        _currentAttacHurt = 10;
        [self attactEnemies];
    }
    else if (hit4count == 36) {
        hit4count = 0;
        [self hitAnimationCallback];
    }
    
//    _body->ApplyForceToCenter(b2Vec2(50,50));
}




-(void) playHitAnimation
{
    if (_playerState == kState_Standing ||_playerState == kState_Running ||_playerState == kState_Jumping || _playerState == kState_NOthing) {
        
        [self stopAllActions];

        NSArray *hurtAmount = @[@10,@10,@20,@20,@20];
        
        _playerState = kState_Hitting;
       
//        if (_currentAttacType > 5) {
//            [self playBodyBomb];
//        }
//        else
//        {
        _currentAttacType =  0;//_currentAttacType%5;
            
//            NSLog(@"_currentAttacType %d", _currentAttacType);
        
        _currentAttacHurt =  [hurtAmount[_currentAttacType] intValue];
//            [self replaceBodyShape:_body withShapeName:[NSString stringWithFormat:@"hit",_currentAttacType]];
                    [self replaceBodyShape:_body withShapeName:@"hit"];
            
            CCAction * hitAction;
            AnimationWapper *wapper = [[[AnimationWapper alloc] init] autorelease];
            
            float animationInterval = 0.02;

            switch (_currentAttacType) {
                case 0:
                    hitAction = [wapper actionWithPrefix:@"hit1/" suffix:@".png" frame:7 frameDelay:animationInterval target:self callback:nil];
                    [self schedule:@selector(hit0Update) interval:animationInterval repeat:6  delay:0];
                    break;
                case 1:
                    hitAction = [wapper actionWithPrefix:@"hit2/" suffix:@".png" frame:9 frameDelay:animationInterval target:self callback:nil];
                    [self schedule:@selector(hit1Update) interval:animationInterval repeat:8 delay:0];
                    _body->ApplyLinearImpulse(b2Vec2(_body->GetMass()*10*self.scaleX,0), _body->GetWorldCenter());
                    break;
                case 2:
                    hitAction = [wapper actionWithPrefix:@"hit3/" suffix:@".png" frame:16 frameDelay:animationInterval  target:self callback:nil];
                    [self schedule:@selector(hit2Update) interval:animationInterval repeat:15 delay:0];
                    break;
                case 3:
                    hitAction = [wapper actionWithPrefix:@"hit4/" suffix:@".png" frame:23 frameDelay:animationInterval  target:self callback:nil];
                    [self schedule:@selector(hit3Update) interval:animationInterval repeat:22 delay:0];
                    break;
                case 4:
                    hitAction = [wapper actionWithPrefix:@"hit5/" suffix:@".png" frame:36 frameDelay:animationInterval target:self callback:nil];
                    [self schedule:@selector(hit4Update) interval:animationInterval repeat:35 delay:0];
                    break;
                default:
                    break;
            }
            
            [self runAction:hitAction];
//        [self addLightEffect];
//    }
    }
}

-(void) turnDirection:(int) direction
{
    if (direction == self.scaleX) {
        return;
    }
    [self setScaleX:direction];
}
-(void) setPhysicPosition
{
    b2Vec2 b2Position = b2Vec2(self.position.x/PTM_RATIO,self.position.y/PTM_RATIO);
    float32 b2Angle = self.scaleX < 0 ? -3.14 : 0;
    _body->SetTransform(b2Position, b2Angle);
}

-(void) sythShapePosition
{
    b2Vec2 bodyPostion = _body->GetPosition();
    self.position = ccp(bodyPostion.x*PTM_RATIO,bodyPostion.y*PTM_RATIO);
}

-(void) update:(ccTime)delta
{
    b2Vec2 speed = _body->GetLinearVelocity();
    
    if (self.isTouchingA) {
         [self playHitAnimation];
        self.isTouchingA = NO;
//        _body->SetLinearVelocity(b2Vec2(0,speed.y));
        speed.x = 0;
    }
    else if (self.isTouchingR)
    {
//        _playerState != kState_Hitting &&
        if ( _playerState != kState_BeingHurt) {
            speed.x += acceleration;
//            _body->ApplyLinearImpulse(b2Vec2((SPEED*_body->GetMass() - speed.x*_body->GetMass()),0),_body->GetWorldCenter());
            [self playRunAnimation];
        }
        self.isTouchingR = NO;
        [self turnDirection:1];
    }
    else if (self.isTouchingL)
    {
        if (_playerState != kState_BeingHurt) {
            speed.x -= acceleration;
//                _body->ApplyLinearImpulse(b2Vec2((-SPEED*_body->GetMass() - speed.x*_body->GetMass()),0),_body->GetWorldCenter());
                [self playRunAnimation];
            }
        self.isTouchingL = NO;
        [self turnDirection:-1];
    }
    else
    {
        speed.x = 0;
        [self playStandbyAnimation];
    }
    
    BOOL _onGround = self.contactFloorCount > 0;
    
    if (_onGround && self.isTouchingB)
    {
        speed.y = jumpHeight;
        [self playBigJumpAnimaiton];
        //_onGround = false; // also removed in the handleEndContact. Useful here if permanent contact e.g. box on hero.
    }
    
    if (self.isTouchingB && !_onGround && speed.y > 0)
    {
        [self playSmallJumpAnimaiton];
        speed.y += jumpAcceleration;
    }
    
    if (speed.x > maxVelocity) {
        speed.x = maxVelocity;
    }
    else if(speed.x < -maxVelocity)
    {
        speed.x = -maxVelocity;
    }
    
    
    _body->SetLinearVelocity(speed);
    [self sythShapePosition];
}


-(void) controlCallBack:(int) tag isBegin:(BOOL) isBegin
{
    switch (tag) {
        case 1:
            self.isTouchingR = YES;
            break;
        case 2:
            self.isTouchingR = YES;
            self.isTouchingB = YES;
            break;
        case 3:
            self.isTouchingB = YES;
            break;
        case 4:
            self.isTouchingL = YES;
            self.isTouchingB = YES;
            break;
        case 5:
            self.isTouchingL = YES;
            break;
        case 6:
            self.isTouchingA = YES;
            self.isTouchingL = NO;
            self.isTouchingR = NO;
            break;
        case 7:
            [self playBodyBomb];
//            [self playBigAttack];
            break;
        default:
            break;
    }
}

-(void)bigAttackAnimationCallback
{
    _playerState = kState_NOthing;
    [self playStandbyAnimation];
}

-(void)playBigAttack
{
    if (_playerState != kState_BigAttack) {
        _playerState = kState_BigAttack;
        AnimationWapper *wapper = [[[AnimationWapper alloc] init] autorelease];
        CCAction* hit4 = [wapper actionWithName:@"playerAnimation1/hit5_" frame:18 target:self callback:@selector(bigAttackAnimationCallback)];
//        CCAction *hit4 = [wapper a]
        [self stopAllActions];
        [self runAction:hit4];
        [[ControlCenter germManager] dealWithBigAttack];
    }
}

- (void)attactEnemiesPlus
{
    [self attactEnemies];
}

-(void)attactEnemies
{
    CCArray* germs = [[ControlCenter germManager] germs];
    MapXRange mapXrange = [[ControlCenter mapManager] mapXRange];
    for (Germ* germ in germs) {
        [self dealWithGerm:germ withMapXrange:mapXrange hitType:_currentAttacType];
    }
}

-(void)dealWithGerm:(Germ*)germ withMapXrange:(MapXRange) mapXRange hitType:(int)hitType
{
    if ([germ germState] == kState_BeingHurt)
    {
        return;
    }
    
    if(_playerState == kState_Hitting && ((self.scaleX == 1 && germ.isMeetingRightNormalHit) || (self.scaleX == -1 && germ.isMeetingLeftNormalHit)))
    {
        [self playHitAudio];
        [germ keepAwayFrom:self withMapXrange:mapXRange hitType:hitType];
        hitGerm = YES;
        [germ hurtWithDamage:_currentAttacHurt];
        _savedEnergy+=1;
        [self addHitEffect:germ];
        
//        NSLog(@"attack interval %f",clock()-_lastAttackTime);
        if ((clock()-_lastAttackTime) < 8000000) {
            _combo++;
        }
        else
        {
            _currentAttacType = 0;
            _combo = 0;
        }
        
        AnimateLabel *label = [[[AnimateLabel alloc] init] autorelease];
        [label createBMLabelSting:[NSString stringWithFormat:@"+%d Hit",_combo+1] pistion:ccp(SCREEN.width*4/5,SCREEN.height*2/3) parent:[GamePlayScene lebalLayer] withDuration:1];
        _lastAttackTime = clock();
    }
}

-(void)playHitAudio
{
    if (!isPlayingHitEffctAudio) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"hit.wav"];
        isPlayingHitEffctAudio = YES;
    }

}

-(void) beginContactWithMapElement:(GB2Contact*)contact
{
    NSString *fixtureId = (NSString *)contact.ownFixture->GetUserData();
    NSString *otherFixtureId = (NSString *)contact.otherFixture->GetUserData();
    
    if ([fixtureId isEqualToString:@"player_body"]) {
        self.contactFloorCount++;
    }
    
    if ([otherFixtureId isEqualToString:@"megma"] && [fixtureId isEqualToString:@"megmaSensor"]) {
        self.health = 0;
    }
}

-(void) endContactWithMapElement:(GB2Contact*)contact
{
    NSString *fixtureId = (NSString *)contact.ownFixture->GetUserData();
    if ([fixtureId isEqualToString:@"player_body"]) {
        self.contactFloorCount--;
    }
}

-(void)hurtWithDamage:(float)damage AccodingToActionSprite:(ActionSprite *)actionSprite withType:(int)type
{
    if (_playerState != kState_BeingHurt && !_invincible) {
        [self playHurtAnimation:type];
        
        if (actionSprite.position.x < self.position.x) {
            desireDirection = -1;
        }
        else
        {
            desireDirection = 1;
        }
//        
//        AnimateLabel *label = [[[AnimateLabel alloc] init] autorelease];
//        [label createBMLabelSting:[NSString stringWithFormat:@"-%f Health",damage] pistion:ccp(self.position.x + (self.scaleX*120),self.position.y + 100) parent:[GamePlayScene lebalLayer] withDuration:2];
        
        self.health -= damage;
    }
}


bool poweradded = NO;
-(void) buttonCallBack:(int)tag power:(float)power
{
    if (tag) {
        self.isTouchingA = YES;
        self.isTouchingR = NO;
        self.isTouchingL = NO;
    }
    else
    {
////        b2Vec2 gravity = [WorldLayer world]->GetGravity();
//        if (self.contactFloorCount > 0 && power<0.15) {
//            poweradded = NO;
//            _body->ApplyLinearImpulse(b2Vec2(0,_body->GetMass()*3), _body->GetWorldCenter());
//            //            NSLog(@"======");
//            [self playSmallJumpAnimaiton];
////            [[ControlCenter worldLayer] scaleSmoothlyTo:0.7 time:2];
//        }
//        else if (power>=0.15 && !poweradded)
//        {
//            poweradded = YES;
//            _body->ApplyLinearImpulse(b2Vec2(0,_body->GetMass()*7), _body->GetWorldCenter());
//            //            NSLog(@"++++");
//            [self playBigJumpAnimaiton];
////            [[ControlCenter worldLayer] scaleSmoothlyTo:0.7 time:2];
//        }
        if (power) {
            self.isTouchingB = YES;
        }
        else
        {
            self.isTouchingB = NO;
        }
        
    }
}

-(void)die
{
    CCLOG(@"player die");
}

-(void)showAnimationCallback
{
    [showAnimationBase removeFromParentAndCleanup:YES];
    _playerState = kState_NOthing;
    [self playStandbyAnimation];
}

-(int)currentAttacType
{
    return _currentAttacType;
}

-(void)onEnter
{
    [super onEnter];
    showAnimationBase = [CCSprite spriteWithSpriteFrameName:@"dustflow/1.png"];
    AnimationWapper* provider = [[[AnimationWapper alloc] init] autorelease];
    CCAction* showAction = [provider actionWithPrefix:@"dustflow/" suffix:@".png" frame:9 target:self callback:@selector(showAnimationCallback)];
    [showAnimationBase runAction:showAction];
    [self addChild:showAnimationBase];
}

-(void)dealloc
{
    [super dealloc];
}

-(void)hitEffectCallBack
{
    _showingHitEffect = NO;
    [self.hitEffect stopAllActions];
    [self.hitEffect removeFromParentAndCleanup:YES];
}

-(void)playBodyBomb
{
    self.savedEnergy = 0;
    [self stopAllActions];
    _playerState = kState_Hitting;
    
    self.scaleX = 1;
    
    AnimationWapper *wapper = [[[AnimationWapper alloc] init] autorelease];
    CCAction *bombAction = [wapper actionWithPrefix:@"bigAttack/" suffix:@".png" frame:22 frameDelay:0.05 target:self callback:nil];
    CCAction *repeat = [CCRepeatForever actionWithAction:(CCActionInterval *)bombAction];
    [self runAction:repeat];
    [self replaceBodyShape:_body withShapeName:@"bomb"];
    
//    _body->SetLinearDamping(0.5);
//    _body->SetGravityScale(5);
//    _body->ApplyLinearImpulse(b2Vec2(0,_body->GetMass()*70), _body->GetWorldCenter());
    [self scheduleOnce:@selector(resetBodyPhisic) delay:6];
    [self schedule:@selector(playBodyBombUpdate)];
    [[ControlCenter mapManager] coverAllMegma:YES];
//    [[ControlCenter germManager] setAllActive:NO];
    _invincible = YES;
}

int bombPlayCount;
-(void)playBodyBombUpdate
{
//    b2Vec2 currentLinearVelocity = _body->GetLinearVelocity();
//    if (currentLinearVelocity.x<0) {
//        _body->SetLinearVelocity(b2Vec2(-currentLinearVelocity.x,currentLinearVelocity.y));
//    }
    
//    [[ControlCenter germManager]  bombPlayed];
    
//    _body->ApplyForceToCenter(b2Vec2(_body->GetMass()*500,0));
    if (bombPlayCount>10) {
        bombPlayCount = 0;
        [self attactEnemies];
    }
    
    bombPlayCount ++;
}



-(void)resetBodyPhisic
{
//    _body->SetLinearDamping(5);
//    _body->SetLinearDamping(0);
//    _body->SetGravityScale(2);
    [self unschedule:@selector(playBodyBombUpdate)];
    _invincible = NO;
//    [[ControlCenter germManager] setAllActive:YES];
    [[ControlCenter mapManager] coverAllMegma:NO];
    
    _playerState = kState_NOthing;
    [self replaceBodyShape:_body withShapeName:@"standby"];
    
//    CGPoint safePosition = [[ControlCenter mapManager] nearestSafePosition];
//    
//    
//    _body->SetTransform(b2Vec2(safePosition.x/PTM_RATIO, safePosition.y/PTM_RATIO), 0);
    _currentAttacType = 0;
    _combo = 0;
    
    [self playStandbyAnimation];
}

-(void)addHitEffect:(Germ *)germ
{
    if (_showingHitEffect) {
        return;
    }
    
    AnimationWapper* hitEffectProvider = [[[AnimationWapper alloc] init] autorelease];
    CCAction* _hitAction = [hitEffectProvider actionWithPrefix:@"hitEffect/01_0" suffix:@".png" frame:6 target:self callback:@selector(hitEffectCallBack)];
    [self.hitEffect runAction:_hitAction];
    [self.parent addChild:_hitEffect];
    [self.hitEffect setPosition:ccpAdd(germ.position, ccp(-self.scaleX*20, 0))];
    _showingHitEffect = YES;

}

- (void)addLightEffect
{
//    CCSprite *light = [CCSprite spriteWithFile:@"white.png"];
//    [light setColor:ccWHITE];
//    [light setScale:0.5];
    ccBlendFunc cbl = {GL_ONE, GL_ONE};
    [self setBlendFunc:cbl];
//    [self addChild:light];
}

-(b2Fixture*)getFixtureById:(NSString*)id
{
    for (b2Fixture* f = _body->GetFixtureList(); f; f = f->GetNext()) {
        if ([(NSString *)f->GetUserData() isEqualToString:id])
        {
            return f;
        }
    }
    return nil;
}

- (b2Body *)body
{
    return _body;
}

-(void)meetFireBall
{
//    self.health = 0;
    [self playHurtAnimation:2];
}
@end
