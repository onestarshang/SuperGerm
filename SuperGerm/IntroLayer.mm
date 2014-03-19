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
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
            background.rotation = 90;
		}
		// add the label as a child to this Layer
		[self addChild: background];
        background.position = ccp(size.width/2, size.height/2);
        
        self.touchEnabled = YES;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ui.plist" ];
	}
	
	return self;
}

- (void)onEnter
{
    CCSprite *pressStart = [CCSprite spriteWithSpriteFrameName:@"pressstart.png"];
    [self addChild:pressStart];
    [pressStart setPosition:ccp(SCREEN.width/3, SCREEN.height*2/3)];
    
    CCFiniteTimeAction *fadeIn = [CCFadeIn actionWithDuration:1];
    CCFiniteTimeAction *fadeOut = [CCFadeOut actionWithDuration:1.5];
    CCSequence *sequence = [CCSequence actionOne:fadeIn two:fadeOut];
    
    [pressStart runAction:[CCRepeatForever actionWithAction:sequence]];
    
    [super onEnter];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
}

@end
