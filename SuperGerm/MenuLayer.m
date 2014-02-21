//
//  MenueLayer.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-12.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "MenuLayer.h"
#import "CCBReader.h"
#import "LevelLayer.h"
#import "AppDelegate.h"

@implementation MenuLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(instancetype)init
{
    if (self = [super init]) {
        //        CCNode* menu = [CCBReader nodeGraphFromFile:@"Menu.ccbi"];
        //        [self addChild:menu];
        //        [self setTouchEnabled:YES];
        
       CCSprite *background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
        [background setAnchorPoint:ccp(0, 0)];
        [self addChild:background];
        [self createGameCenterMenu];
    }
    return self;
}

-(void) createGameCenterMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
    
	CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"GameCenter" block:^(id sender) {
		
        [[GameKitHelper sharedGameKitHelper]
         showGameCenter];
	}];
    
    // Leaderboard Menu Item using blocks
	CCMenuItem *startGame = [CCMenuItemFont itemWithString:@"StartGame" block:^(id sender) {
		[[CCDirector sharedDirector] replaceScene:[LevelLayer scene]];
	}];
    
    // Leaderboard Menu Item using blocks
	CCMenuItem *enableBackGroundMusic = [CCMenuItemFont itemWithString:@"enableBackGroundMusic" block:^(id sender) {
		[GamePreference sharedGamePreference].backGroundMusicEnable = YES;
	}];
    
    CCMenuItem *enableEffectMusic = [CCMenuItemFont itemWithString:@"enableEffectMusic" block:^(id sender) {
		[GamePreference sharedGamePreference].effectMusicEnable = YES;
	}];

    
	
	CCMenu *menu = [CCMenu menuWithItems:startGame,itemLeaderboard,enableBackGroundMusic, enableEffectMusic,nil];
	
	[menu alignItemsVerticallyWithPadding:50];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	
	[self addChild:menu];
}

- (void)onEnter
{
    [super onEnter];
    [[GameKitHelper sharedGameKitHelper]
     authenticateLocalPlayer];
}

@end
