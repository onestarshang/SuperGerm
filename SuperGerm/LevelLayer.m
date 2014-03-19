//
//  LevelLayer.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-12.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "LevelLayer.h"
#import "CCBReader.h"
#import "AreaLayer.h"

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
        [self addChild:background];
        background.rotation = 90;
        [background setPosition:ccp(SCREEN.width/2, SCREEN.height/2)];
        
        AreaLayer *area = [[AreaLayer alloc] init];
        [self addChild:area];
        
     CCMenuItem  *returnButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"returnButton1.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"returnButton2.png"] block:^(id sender) {
            [[CCDirector sharedDirector] popScene];
        }];
        
        
        CCSprite *bottom = [CCSprite spriteWithSpriteFrameName:@"levelLayerDecorator.png"];
        [self addChild:bottom];
        [bottom setAnchorPoint:ccp(0.5, 0)];
        [bottom setPosition:ccp(SCREEN.width/2, 0)];
       
        CCSprite *player = [CCSprite spriteWithSpriteFrameName:@"levelDecoratorPlayer.png"];
        [self addChild:player];
        [player setPosition:ccp(50, 60)];
        
        CCMenu *returnMenu = [CCMenu menuWithItems:returnButton, nil];
        [self addChild:returnMenu];
        [returnMenu setPosition:ccp(SCREEN.width-50, 50)];
        

        [self setTouchEnabled:YES];
    }
    return self;
}

- (void)onEnter
{
//    CCNode* level = [CCBReader nodeGraphFromFile:@"Level.ccbi"];
//    [self addChild:level];
    
    [super onEnter];

}

@end
