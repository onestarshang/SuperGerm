//
//  Player.h
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-10.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

@class Germ;
#import "ActionSprite.h"
#import "ControlLayer.h"
#import "GB2Contact.h"
#import "Germ.h"

@interface Player:ActionSprite <SimpleDPadDelegate>
-(void) playRunAnimation;
-(void) playStandbyAnimation;
-(void) playHitAnimation;
- (void)playBodyBomb;
-(void) playSmallJumpAnimaiton;
-(void) playBigJumpAnimaiton;
-(void) turnDirection:(int) direction;
-(void) setPhysicPosition;
-(void)hurtWithDamage:(int)damage AccodingToActionSprite:(ActionSprite *)actionSprite withType:(int)type;
-(void)dealWithGerm:(Germ*)germ withMapXrange:(MapXRange) mapXRange hitType:(int)hitType;
-(int)currentAttacType;
-(void)meetFireBall;
- (b2Body *)body;
//@property (nonatomic,strong) CCAction *standbyAction;
//@property (nonatomic,strong) CCAction *beingHurtAction;
//@property (nonatomic,strong) CCAction *moveAction;
//@property (nonatomic,strong) CCAction *hitAction;
//@property (nonatomic,strong) CCAction *comboHitAction;
@property (nonatomic,assign) int playerState;
@property (nonatomic,assign) int combo;
@property (nonatomic) BOOL isTouchingA;
@property (nonatomic) BOOL isTouchingB;
@property (nonatomic) BOOL isTouchingR;
@property (nonatomic) BOOL isTouchingL;
@property (nonatomic) CGPoint targetPostion;
@property (nonatomic,retain) CCSprite* hitEffect;
@end
