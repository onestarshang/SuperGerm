//
//  GamePlayScene.m
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-3.
//  Copyright Ariequ 2013年. All rights reserved.
//


// Import the interfaces
#import "GamePlayScene.h"
#import "ControlCenter.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "AnimationWapper.h"
#import "Player.h"
#import "WorldLayer.h"
#import "HudLayer.h"
#import "SimpleAudioEngine.h"
#import "GameModel.h"

#pragma mark - GamePlayScene

float PTM_RATIO = 32;

// GamePlayScene implementation
@implementation GamePlayScene
{
    Player *player;
    WorldLayer *world;
    HudLayer *hud;
    
    CCSprite* background1;
    CCSprite* background2;
    CCSprite* background3;

    CCSprite* cell;
}

static CCLayer *lebalLayer;
static ControlLayer *controlLayer;
static CCLayer *_popLayer;

// Helper class method that creates a Scene with the GamePlayScene as the only child.
+(CCScene *) sceneWithLevel:(int)level
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GamePlayScene *layer = [[GamePlayScene alloc] initWithLevel:[GameModel sharedGameModel].level];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (CCScene *)scene
{
    return [GamePlayScene sceneWithLevel:1];
}

+(CCLayer *) lebalLayer
{
    return lebalLayer;
}

// on "init" you need to initialize your instance

-(instancetype) initWithLevel:(int)level
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		[self setTouchEnabled:YES];

//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"background.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hero.plist" ];
        background1 = [CCSprite spriteWithFile:@"back1.png"];
        [self addChild:background1];
        [background1 setAnchorPoint:ccp(0, 0)];
        ccTexParams tp1 = {GL_LINEAR, GL_LINEAR, GL_REPEAT,GL_LINEAR};
        [background1.texture setTexParameters:&tp1];
        [background1 setScale:1.5];
        
        background2 = [CCSprite spriteWithFile:@"back2.png"];
        [self addChild:background2];
        [background2 setAnchorPoint:ccp(0, 0)];
        ccTexParams tp2 = {GL_LINEAR, GL_LINEAR, GL_REPEAT,GL_LINEAR};
        [background2.texture setTexParameters:&tp2];
        [background2 runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCMoveBy actionWithDuration:1 position:ccp(0, 5)], [CCMoveBy actionWithDuration:1 position:ccp(0, -5)],nil]]];
        
        background3 = [CCSprite spriteWithFile:@"back3.png"];
        [self addChild:background3];
        [background3 setAnchorPoint:ccp(0, 0)];
        ccTexParams tp3 = {GL_LINEAR, GL_LINEAR, GL_REPEAT,GL_LINEAR};
        [background3.texture setTexParameters:&tp3];

        
        cell = [CCSprite spriteWithFile:@"cell.png"];
        [self addChild:cell];
        [cell setAnchorPoint:ccp(0,0)];
        [cell setPosition:ccp(0, SCREEN.height/2)];
        ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT,GL_LINEAR};
        [cell.texture setTexParameters:&tp];
        
        
        
        //add worldLayer
        world =[ControlCenter worldLayer];//
        [world initializeWithLevel:level];
//        [self addChild:world];
        player = world.player;
        
        CCLayer* content = [[CCLayer alloc]init];
        [content addChild:world];
        [self addChild:content];
//        [content setScale:0.8];
        
        lebalLayer = [[CCLayer alloc] init];
        [self addChild:lebalLayer];
        
        hud = [[HudLayer alloc] init];
        [self addChild:hud];
        
        controlLayer = [[ControlLayer alloc] init];
        [self addChild:controlLayer];
        controlLayer.delegate = player;
        
        [[GamePlayScene controlLayer] setControlEnable:NO];
        
        [self initSound];
        
        _popLayer = [[CCLayer alloc] init];
        [self addChild:_popLayer];
        
        [self scheduleUpdate];
    
    }
	return self;
}

-(void)initSound
{
//    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"blue.mp3" loop:YES];
//    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1];
}

-(void)onEnter
{
    [super onEnter];
}

- (void)onExit
{
    [super onExit];
    player = nil;
    [world release];
    [world removeFromParentAndCleanup:YES];
    world = nil;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"

    [super dealloc];

}

//#pragma mark GameKit delegate
//
//-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
//{
//	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
//}
//
//-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
//{
//	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
//}

//static int offset = 0;
-(void) update:(ccTime)delta
{
    [cell setTextureRect:CGRectMake(-world.position.x*0.4, 0, SCREEN.width,SCREEN.height)];
    [cell setPosition:ccp(0, world.position.y*0.1+SCREEN.height/2)];
    
    [background1 setTextureRect:CGRectMake(-world.position.x*0.2, 0, SCREEN.width,SCREEN.height)];
    [background1 setPosition:ccp(0, 0+world.position.y*0.2)];

    [background2 setTextureRect:CGRectMake(-world.position.x*0.3, 0, SCREEN.width,SCREEN.height)];
//    [background2 setPosition:ccp(background2.position.x, background2.position.y+world.position.y*0.2)];

    [background3 setTextureRect:CGRectMake(-world.position.x*0.4, 0, SCREEN.width,SCREEN.height)];
    [background3 setPosition:ccp(0, -SCREEN.height/3+world.position.y*0.2)];


//    [hud updateHealthPercent:player.health/player.totalHealth];

    [hud update:delta];
    
    [controlLayer updateHitProgress:[player savedEnergy]/1.0];
    
//    NSLog(@"start time %f",[[NSData data] timeIntervalSinceNow]);


//    [[self camera] setEyeX:0 eyeY:0 eyeZ:offset++];
}

+ (ControlLayer *)controlLayer
{
    return controlLayer;
}

+ (CCLayer *)popLayer
{
    return _popLayer;
}

@end
