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
#import "AreaLayer.h"
#import "SimpleAudioEngine.h"

@implementation MenuLayer
{
    CCMenuItem *startGame;
    CCMenuItem *itemLeaderboard;
    CCMenuItem *musicOn;
    CCMenuItem *musicOff;
    CCMenuItemToggle *toggleItem;
}
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
        background.rotation = 90;
        background.position = ccp(SCREEN.width/2, SCREEN.height/2);
        [self addChild:background];

        CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(0,0,0,100)];
        [self addChild:colorLayer];
        
        [self createGameCenterMenu];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"blue.mp3" loop:YES];
    }
    return self;
}

-(void) createGameCenterMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
    
    startGame = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"startGameMenu1.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"startGameMenu2.png"] block:^(id sender) {
        [[CCDirector sharedDirector] pushScene:[LevelLayer scene]];
    }];
    
	itemLeaderboard = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"gameCenterMenu1.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"gameCenterMenu2.png"]block:^(id sender) {
		
        [[GameKitHelper sharedGameKitHelper]
         showGameCenter];
	}];
	
	CCMenu *menu = [CCMenu menuWithItems:startGame,itemLeaderboard,nil];
	[menu alignItemsVerticallyWithPadding:10];
	[menu setPosition:ccp(150,250)];
	[self addChild:menu];
    
    musicOn = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"musicOnMenu.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"musicOnMenu.png"]];
    musicOff = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"musicOffMenu.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"musicOffMenu.png"]];
    
    toggleItem = [CCMenuItemToggle itemWithTarget:self
                                                           selector:@selector(musicSwitchPressed:) items:musicOn, musicOff, nil];
    CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
    toggleMenu.position = ccp(150, 180);
    [toggleMenu alignItemsVerticallyWithPadding:5];
    [self addChild:toggleMenu];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"backGroundMusicEnable"]) {
        [toggleItem setSelectedIndex:1];
    }
    else
    {
        [toggleItem setSelectedIndex:0];
    }
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"effectMusicEnable"]) {
//        _effectMusicEnable = YES;
//    }

}

- (void)musicSwitchPressed:(id)sender
{
    CCMenuItemToggle *toggle = (CCMenuItemToggle *)sender;
    if (toggle.selectedItem == musicOn)
    {
        [GamePreference sharedGamePreference].backGroundMusicEnable = NO;
        [GamePreference sharedGamePreference].effectMusicEnable = NO;
    }
    else if (toggle.selectedItem == musicOff)
    {
        [GamePreference sharedGamePreference].backGroundMusicEnable = YES;
        [GamePreference sharedGamePreference].effectMusicEnable = YES;
    }
}

- (void)onEnter
{
    [super onEnter];
    [[GameKitHelper sharedGameKitHelper]
     authenticateLocalPlayer];
    
   
    [startGame setPosition:ccp(startGame.position.x-300, startGame.position.y)];
    [itemLeaderboard setPosition:ccp(itemLeaderboard.position.x-300, itemLeaderboard.position.y)];
    
    
//    [musicOn setPosition:ccp(musicOn.position.x-300, musicOn.position.y)];
//    [musicOff setPosition:ccp(musicOff.position.x-300, musicOff.position.y)];
    
    CCNode *currentMenuItem = [toggleItem selectedItem];
    [currentMenuItem setPosition:ccp(currentMenuItem.position.x - 300, currentMenuItem.position.y)];
    
    [self moveIn:startGame withDelay:0.1];
    [self moveIn:itemLeaderboard withDelay:0.3];
    [self moveIn:currentMenuItem withDelay:0.5];

}

- (void)moveIn:(CCNode *)target withDelay:(float)delayTime
{
     CCActionInterval *delay = [CCDelayTime actionWithDuration:delayTime];
    CCActionInterval *fadeIn = [CCEaseIn actionWithAction:[CCMoveBy actionWithDuration:0.5 position:ccp(300, 0)] rate:2 ];
    CCSequence *sequence = [CCSequence actionOne:delay two:fadeIn];
    [target runAction:sequence];
}

@end
