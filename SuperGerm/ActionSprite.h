//
//  ActionSprite.h
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-20.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D/Box2D.h"
#import "GB2ShapeCache.h"
#import "GB2Engine.h"
#import "AnimationWapper.h"

typedef enum {
	kState_Standing = 0,
	kState_Running = 1,
    kState_Hitting = 2,
    kState_NOthing = 3,
    kState_ComboHitting = 4,
    kState_BeingHurt = 5,
    kState_ContactWithNormalHit = 6,
    kState_ContactWithCombolHit = 7,
    kState_Jumping = 8,
    kState_BigAttack = 9,
    kState_Faint = 10,
    KState_Growing = 11,
    kState_Pre_Hitting = 12
}k_State;

@interface ActionSprite : CCSprite
{
    b2Body* _body;
//    AnimationWapper* actionProvider;
}

@property(nonatomic,assign)b2Vec2 velocity;
@property (nonatomic,assign)float health;
@property (nonatomic,assign)float totalHealth;

-(void) update:(ccTime)delta;
-(void) replaceBodyShape:(b2Body *)body withShapeName:(NSString*)shapeName;
-(void) setupBody;
-(void) sythShapePosition;
@end
