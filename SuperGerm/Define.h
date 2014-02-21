//
//  Define.h
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-20.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

// 1 - convenience measurements
#define SCREEN [[CCDirector sharedDirector] winSize]
#define CENTER ccp(SCREEN.width/2, SCREEN.height/2)
#define CURTIME CACurrentMediaTime()

// 2 - convenience functions
#define random_range(low,high) (arc4random()%(high-low+1))+low
#define frandom (float)arc4random()/UINT64_C(0x100000000)
#define frandom_range(low,high) ((high-low)*frandom)+low

// 3 - enumerations
typedef enum _ActionState {
    kActionStateNone = 0,
    kActionStateIdle,
    kActionStateAttack,
    kActionStateWalk,
    kActionStateHurt,
    kActionStateKnockedOut
} ActionState;

typedef enum {
    kFixtureBody,
    kFixtureRightHit,
    kFixtureRightComboHit,
    kFixtureLeftHit,
    kFixtureLeftComboHit
}FixtureTag;

// 4 - structures
typedef struct _BoundingBox {
    CGRect actual;
    CGRect original;
} BoundingBox;

struct MapXRange {
    CGFloat left;
    CGFloat right;
};
typedef struct MapXRange MapXRange;
