//
//  HelloWorldLayer.h
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-3.
//  Copyright Ariequ 2013年. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCBReader.h"
#import "WorldLayer.h"
#import "ControlLayer.h"

// HelloWorldLayer
@interface GamePlayScene : CCLayer
{
}
//@property (nonatomic, strong) CCSprite *bear;
//@property (nonatomic, strong) CCAction *walkAction;
//@property (nonatomic, strong) CCAction *moveAction;
//@property (nonatomic,strong) CCSprite *background;

//@property (nonatomic) BOOL isTouchingA;
//@property (nonatomic) BOOL isTouchingB;
//@property (nonatomic) BOOL isTouchingR;
//@property (nonatomic) BOOL isTouchingL;

+(CCScene *) sceneWithLevel:(int)level;
+ (CCScene *)scene;
+(CCLayer *)lebalLayer;
+ (ControlLayer *)controlLayer;
+ (CCLayer *)popLayer;
@end
