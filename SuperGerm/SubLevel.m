//
//  SubLevel.m
//  SuperGerm
//
//  Created by Ariequ on 14-3-20.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "SubLevel.h"
#import "CCBReader.h"

@implementation SubLevel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        CCSprite *background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
        background.rotation = 90;
        background.position = ccp(SCREEN.width/2, SCREEN.height/2);
        [self addChild:background];
        
        CCNode* level = [CCBReader nodeGraphFromFile:@"Level.ccbi"];
        [self addChild:level];
        
        CCMenuItem  *returnButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"returnButton1.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"returnButton2.png"] block:^(id sender) {
            [[CCDirector sharedDirector] popScene];
        }];
        
        CCMenu *returnMenu = [CCMenu menuWithItems:returnButton, nil];
        [self addChild:returnMenu];
        [returnMenu setPosition:ccp(SCREEN.width-50, 50)];

    }
    return self;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SubLevel *layer = [SubLevel node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@end
