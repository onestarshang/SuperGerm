//
//  HudLayer.m
//  SuperGerm
//
//  Created by Ariequ on 13-11-7.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "HudLayer.h"
#import "HealthHeart.h"
//#import "CCProgressTimer.h"
//#import "CCLabelTTF.h"
//#import "CGPointExtension.h"
//#import "Define.h"
//#import "CCDirector.h"
//#import "CCLabelBMFont.H"

@implementation HudLayer
{
    CCProgressTimer *energyProgress;
    CCLabelBMFont* scoreLabel;
    HealthHeart *heartUI;
}

-(instancetype)init
{
    if (self = [super init]) {
//        energyProgress = [CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:@"energy.png"]];
//        [self addChild:energyProgress];
//        [energyProgress setType:kCCProgressTimerTypeBar];
//        [energyProgress setPercentage:100];
//        [energyProgress setMidpoint:ccp(0, 0.5)];
//        [energyProgress setBarChangeRate:ccp(1, 0)];
//        
//        CCSprite *energyBack = [CCSprite spriteWithSpriteFrameName:@"energyBack.png"];
//        [self addChild:energyBack];
//        [energyBack setAnchorPoint:ccp(0.5, 0.5)];
//        energyBack.position = ccp([energyBack contentSize].width/2, SCREEN.height - [energyBack contentSize].height/2);
//        
//        [energyProgress setPosition:ccpAdd(ccp(23,-5),ccp(energyBack.position.x, energyBack.position.y))];
        
        heartUI = [[HealthHeart alloc] initWithTotalBlood:3];
        [self addChild:heartUI];
        [heartUI setPosition:ccp(-20, SCREEN.height - 30)];
        
        scoreLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"hittext.fnt"];
        [scoreLabel setString:@"SCORE:"];
        [self addChild:scoreLabel];
        [scoreLabel setPosition:ccp(SCREEN.width-[scoreLabel contentSize].width,SCREEN.height-[scoreLabel contentSize].height/2)];
        
    }
    
    return self;
}

-(void)updateHealthPercent:(float)percent
{
    [energyProgress setPercentage:100*percent];
}

- (void)updateHealth:(float)health
{
    [heartUI drawBlood:health];
}

-(void)updateScore:(int)score
{
    [scoreLabel setString:[NSString stringWithFormat:@"SCORE:%d",score]];
}
@end
