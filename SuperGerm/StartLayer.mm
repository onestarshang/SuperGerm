//
//  StartLayer.m
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-16.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "StartLayer.h"
#import "GamePlayScene.h"
#import "AnimationWapper.h"

@implementation StartLayer
{
    CCSprite* startAnimationBace;
    CCActionInterval* introAction;
}

-(instancetype)init
{
    if (self = [super init]) {
//        CCLayerColor *blueSky = [[CCLayerColor alloc] initWithColor:ccc4(100, 100, 250, 255)];
//        [self addChild:blueSky];

    }
    return self;
}


- (void) didLoadFromCCB
{
    CGPoint animtionPositon = animation.position;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"openAnimation.plist"];
    startAnimationBace = [CCSprite spriteWithSpriteFrameName:@"openAnimation/0000"];
    [startAnimationBace setAnchorPoint:ccp(0,0)];
    [startAnimationBace setPosition:ccp(animtionPositon.x-20,animtionPositon.y-45)];
    [self addChild:startAnimationBace];
//    [startAnimationBace setScale:1.05];
    AnimationWapper* actionProvider = [[[AnimationWapper alloc] init] autorelease];
    introAction = (CCActionInterval*)[actionProvider actionWithName:@"openAnimation/" frame:125 target:self callback:nil];
    [startAnimationBace runAction:[CCRepeatForever actionWithAction:introAction]];

}

-(void)buttonPressed:(id)sender {
//    CCControlButton *button = (CCControlButton*) sender;
//    switch (button.tag) {
//        case PLAY_BUTTON_TAG:
//            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0 scene:[CCBReader sceneWithNodeGraphFromFile:@"GameScene.ccbi"]]];
//            break;
//        case OPTIONS_BUTTON_TAG:
//            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:1.0 scene:[CCBReader sceneWithNodeGraphFromFile:@"OptionsScene.ccbi"]]];
//            break;
//        case ABOUT_BUTTON_TAG:
//            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0 scene:[CCBReader sceneWithNodeGraphFromFile:@"AboutScene.ccbi"]]];
//            break;
//    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0 scene:[GamePlayScene scene] ]];
}

- (void)onEnter
{
    [super onEnter];
}

@end
