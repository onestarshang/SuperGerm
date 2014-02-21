//
//  IntroLayer.m
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-3.
//  Copyright Ariequ 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "GameStartScene.h"
#import "MenuLayer.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init])) {

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
//			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
		}
		// add the label as a child to this Layer
		[self addChild: background];
        background.position = ccp(size.width/2, size.height/2);
        
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"background.plist"];

        
        self.touchEnabled = YES;
        
	}
	
	return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
//    [[CCDirector sharedDirector] replaceScene:[[GameStartScene alloc] init]];
}

@end
