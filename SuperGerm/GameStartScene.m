//
//  GameStartScene.m
//  SuperGerm
//
//  Created by Ariequ on 13-12-21.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "GameStartScene.h"
#import "CCBReader.h"
#import "AnimationWapper.h"

@implementation GameStartScene
{
    CCSprite* startAnimationBace;
    CCAction* introAction;
}


-(instancetype)init
{
    if (self = [super init]) {        
        CCSprite *background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
        [self addChild:background];
        background.rotation = 90;
        [background setPosition:CENTER];
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    CCNode *node = [CCBReader sceneWithNodeGraphFromFile:@"StartUI.ccbi"];
    [self addChild:node];
    [node setPosition:ccp(0, SCREEN.height/2)];
    
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.5 position:ccp(0,0)];
    CCEaseBackOut *fadeIn = [CCEaseBackOut actionWithAction:moveTo];
    
    [node runAction:fadeIn];

}

- (void)dealloc
{
    [startAnimationBace release];
    [introAction release];
    [super dealloc];
}


@end
