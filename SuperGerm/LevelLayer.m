//
//  LevelLayer.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-12.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "LevelLayer.h"
#import "CCBReader.h"

@implementation LevelLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelLayer *layer = [LevelLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(instancetype)init
{
    if (self = [super init]) {
        CCSprite *background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
        [background setAnchorPoint:ccp(0, 0)];
        [self addChild:background];


        [self setTouchEnabled:YES];
    }
    return self;
}

- (void)onEnter
{
    CCNode* level = [CCBReader nodeGraphFromFile:@"Level.ccbi"];
    [self addChild:level];
        
    [super onEnter];

}

@end
