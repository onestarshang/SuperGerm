//
//  Germ.h
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-15.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "ActionSprite.h"
#import "GB2Contact.h"
#import "AnimationWapper.h"
#import "WorldLayer.h"
#import "ControlCenter.h"

enum{
    WAITING_MODEL,
    FLYING_MODEL,
    PRODUCE_MODEL,
    READY_ATTACK_MODEL,
    ATTACK_MODEL
};

@interface Germ : ActionSprite
{
    int _germState;
    BOOL _isMeetingNormalHit;
    BOOL _isMeetingComboHit;
    BOOL _isReadyToAttack;
    BOOL _isMeetingPlayerbody;
    
    BOOL _isMeetingRightNormalHit;
    BOOL _isMeetingLeftNormalHit;
    
    float _damage;
    BOOL _awake;
    int _direction;
    
    float WAITINGMODELLASTTIME;
    float FLYINGMODELLASTTIME;
    
    float timeGap;
    CGPoint oringinalPositon;
}

@property (nonatomic) int AIModel;
@property (nonatomic,assign) float ATK;
@property (nonatomic,assign) BOOL isMeetingRightNormalHit;
@property (nonatomic,assign) BOOL isMeetingLeftNormalHit;
@property (nonatomic)int awakeDistance;

- (BOOL)isMeetingNormalHit;
- (BOOL)isMeetingComboHit;

- (void) playStandByAnimation;
- (void) standbyCallback;

- (void) playAfraidAnimation;

- (void)playHitAnimation;
- (void)hurtAnimationCallBack;
- (void)hitCallback;
- (void)enterCallback;
- (void)playEnterAnimation;
- (void)playHurtAnimation:(int)damage;
- (void)updatePosition:(ccTime) t towards:(CCSprite *)player;
- (void)keepAwayFrom:(CCSprite *)player withMapXrange:(MapXRange) mapXRange hitType:(int)hitType;
- (void)hurtWithDamage:(int) damage;
- (void)beginContactWithGerm:(GB2Contact*)contact;
- (void)beginContactWithPlayer:(GB2Contact *)contact;
- (void)setAwake:(BOOL) awake;
- (int)germState;
- (void)die;

- (b2Body*)body;
- (void)sythShapePosition;
- (void)dealWithPlayer:(CCSprite*)player;
- (void)setReadyToAttack;
- (BOOL)isAwake;
- (b2Vec2)attackImpulse:(int)hitType;
- (void)dealWithBigAttack;
- (void)setActive:(BOOL)isActiv;
- (void)turnDirection:(int)direction;
- (void)setupBody;
- (BOOL)isInScreen;
@end
