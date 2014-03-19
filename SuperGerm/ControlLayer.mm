//
//  ControlLayer.m
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-7.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "ControlLayer.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "GamePlayScene.h"

@implementation ControlLayer
{
    SneakyButton* jumpButton;
    SneakyButton* hitButton;

    CCMenuItem *_pauseItem;
    CCMenuItem *_resumeItem;
    
    CCJoyStick* joyStick;
    
    CCProgressTimer *hitProgress;
    
    CCMenu *bigHit;
}

-(id) init
{
    if (self=[super init])
    {
        [self addControlMenue];
        [[[CCDirector sharedDirector]openGLView]setMultipleTouchEnabled:YES];
        
    }
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return false;
}

- (void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeAllDelegates];
    [super onExit];
}

- (void)onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}



NSMutableArray *controlItems;
-(void) addControlMenue
{
    joyStick = [CCJoyStick initWithBallRadius:20 MoveAreaRadius:50 isFollowTouch:NO isCanVisible:YES isAutoHide:NO hasAnimation:YES];
    [joyStick setBallTexture:@"console.png"];
    [joyStick setDockTexture:@"consolebackground.png"];
    [self addChild:joyStick];
    [joyStick setPosition:ccp(74,64)];
    [joyStick setDelegate:self];
    
    [self addJumpButton];
    [self addHitButton];
    [self addPauseButton];
    [self addHitProgress];
//    [self addBigAttackButton];
    
    
    [self scheduleUpdate];
}

- (void)addHitProgress
{
    CCSprite *hitProgressBack = [CCSprite spriteWithSpriteFrameName:@"hitProgressBack.png"];
    [self addChild:hitProgressBack];
    [hitProgressBack setAnchorPoint:ccp(0.5, 0.5)];
    hitProgressBack.position = ccp(SCREEN.width/2 - 50, [hitProgressBack contentSize].height);
    [hitProgressBack setScale:0.5];
    
    hitProgress = [CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:@"hitProgress.png"]];
    [self addChild:hitProgress];
    [hitProgress setType:kCCProgressTimerTypeBar];
    [hitProgress setPercentage:100];
    [hitProgress setMidpoint:ccp(0, 0.5)];
    [hitProgress setBarChangeRate:ccp(1, 0)];
    [hitProgress setPosition:ccpAdd(ccp(-10,0),ccp(hitProgressBack.position.x, hitProgressBack.position.y))];
    [hitProgress setScale:0.5];
    
    [self addBigAttackButton];
}

-(void)bigAttacTapped:(id)sender
{
    [_delegate controlCallBack:7 isBegin:YES];
    [bigHit setEnabled:NO];
}

-(void)addBigAttackButton
{
    CCMenuItem *hitMenuItem = [[CCMenuItemImage alloc] initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bigHitButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bigHitButton.png"] disabledSprite:[CCSprite spriteWithSpriteFrameName:@"bigHitButton.png"] target:self selector:@selector(bigAttacTapped:)];
    hitMenuItem.position = ccp(SCREEN.width/2 + 30, 0);
    bigHit = [CCMenu menuWithItems:hitMenuItem, nil];
    bigHit.position = CGPointZero;
    [self addChild:bigHit];
    [bigHit setPosition:ccp(0, -40)];
    [bigHit setEnabled:NO];
    [bigHit setScale:0.5];
}

-(void)addJumpButton
{
    float buttonRadius = 40;

    jumpButton = [[SneakyButton alloc]initWithRect:CGRectZero];
    [jumpButton setHoldable:YES];
    
    SneakyButtonSkinnedBase* skin = [[SneakyButtonSkinnedBase alloc]init];
    [skin setDefaultSprite:[CCSprite spriteWithFile:@"jump_common.png"]];
    [skin setPressSprite:[CCSprite spriteWithFile:@"jump_pressed.png"]];
    [skin setButton:jumpButton];
    [skin setPosition:ccp(SCREEN.width - buttonRadius-10, buttonRadius+25)];
    
    [self addChild:skin];
    
//    [skin setScale:0.7];
}

-(void)addHitButton
{
    float buttonRadius = 40;
    
    hitButton = [[SneakyButton alloc]initWithRect:CGRectZero];
    [hitButton setHoldable:NO];
    
    SneakyButtonSkinnedBase* skin = [[SneakyButtonSkinnedBase alloc]init];
    [skin setDefaultSprite:[CCSprite spriteWithFile:@"hit_common.png"]];
    [skin setPressSprite:[CCSprite spriteWithFile:@"hit_pressed.png"]];
    [skin setButton:hitButton];
    [skin setPosition:ccp(SCREEN.width - 3*buttonRadius-15, buttonRadius+5)];
    
    [self addChild:skin];
    
//    [skin setScale:0.7];
}

-(void)pauseButtonTapped:(id)sender
{
    
    CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    if (toggleItem.selectedItem == _pauseItem) {
        [[CCDirector sharedDirector] pause];
    } else if (toggleItem.selectedItem == _resumeItem) {
        [[CCDirector sharedDirector] resume];
    }
}

-(void)addPauseButton
{
   _pauseItem = [[CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pause_normal.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"pause_normal.png"] target:nil selector:nil] retain];
    
    _resumeItem = [[CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pause_pressed.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"pause_pressed.png"] target:nil selector:nil] retain];
    CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self
                                                           selector:@selector(pauseButtonTapped:) items:_resumeItem,_pauseItem ,nil];
    CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
    toggleMenu.position = ccp(SCREEN.width/2, SCREEN.height - 25);
    [self addChild:toggleMenu];
}


- (void) onCCJoyStickUpdate:(CCNode*)sender Angle:(float)angle Direction:(CGPoint)direction Power:(float)power
{
    int targetDirection = direction.x>0?1:5;
    [_delegate controlCallBack:targetDirection isBegin:YES];
}

-(void)hitButtonTapped:(id)sender
{
    [_delegate controlCallBack:6 isBegin:YES];
}

float jumpButtonHoldingTime;
float hitButtonHoldingTime;
-(void)update:(ccTime)delta
{
    if ([jumpButton active]) {
        jumpButtonHoldingTime += delta;
        [_delegate buttonCallBack:0 power:jumpButtonHoldingTime];
//        CCLOG(@"jumpButtonHoldingTime %f",jumpButtonHoldingTime);                                                                                                       
    }
    else
    {
        jumpButtonHoldingTime = 0;
//        [_delegate buttonCallBack:0 power:jumpButtonHoldingTime];
    }
    
    if ([hitButton active]) {
        [_delegate buttonCallBack:1 power:hitButtonHoldingTime];
    }
}

- (void)setControlEnable:(BOOL)enable
{
    [joyStick setTouchEnabled:enable];
    hitButton.isToggleable = enable;
    jumpButton.isToggleable = enable;
}

- (void)updateHitProgress:(float)progress
{
    [hitProgress setPercentage:progress*100];
    
    if (progress >= 1) {
        [bigHit setEnabled:YES];
    }
}

@end
