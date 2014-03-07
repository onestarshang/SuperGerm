//  GermManager.m
//  SuperGerm
//
//  Created by Ariequ on 13-10-26.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "GermManager.h"
#import "ControlCenter.h"
#import <objc/runtime.h>
#import "CCBReader.h"
#import "Boss.h"
#import "GamePlayScene.h"
#import "EndGameLayer.h"

const int germCount = 12;

@implementation GermManager
{
    CCNode *_parent;
    int score;
    int killNum;
    BOOL endPanelAdded;
}

-(instancetype) init
{
    if (self = [super init]) {
        _germs = [[CCArray alloc] initWithCapacity:germCount];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"germ.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemy2.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"DrippingGerm.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"BulletGerm.plist" ];
    }
    return self;
}

-(void)initParent:(CCNode *)parent player:(Player *)player
{
    _parent = parent;
    _player = player;
}

-(GermManager *) initWithTileMap:(CCTMXTiledMap *)tileMap player:(Player *)player parent:(CCLayer *)parent
{
    if (self = [self init]) {
        
        _player = player;
        _parent = parent;
        
        CCTMXObjectGroup *objectGroup = [tileMap objectGroupNamed:@"obj"];
        NSAssert(objectGroup != nil, @"tile map has no objects object layer");
        
        _germs = [[CCArray alloc] initWithCapacity:germCount];
        for (int i=1; i<=12; i++) {
            NSDictionary *spawnPoint = [objectGroup objectNamed:[NSString stringWithFormat:@"position%d",i]];
            int x = [spawnPoint[@"x"] integerValue];
            int y = [spawnPoint[@"y"] integerValue];
            
            CCLOG(@"generate germ position %d,%d",x,y);
            
            Germ *germ = [[Germ alloc] init];
            
            [parent addChild:germ];
            germ.position = ccp(x/2, y/2);
            
            [germ setupBody];
            [germ playStandByAnimation];
            [_germs addObject:germ];
        }
    }
    return self;
}

-(void)addGermInTileMap:(CCTMXTiledMap *)tileMap
{
    for (CCTMXObjectGroup* objectGroup in [tileMap objectGroups])
    {
        for( id object in [objectGroup objects] )
        {
            NSString* groupName = [objectGroup groupName];
            Class germClass = NSClassFromString(groupName);
            NSObject* obj = [[[germClass alloc] init] autorelease];
            if (germClass && [obj isKindOfClass:[Germ class]])
            {
                int x = [object[@"x"] integerValue];
                int y = [object[@"y"] integerValue];
                
//                NSLog(@"%@ Position: x=%d,y=%d",groupName,x,y);
                
                Germ *germ = (Germ*)obj;
                [_parent addChild:germ];
                germ.position = ccp(x/2,y/2);
                [germ setupBody];
//                [germ playEnterAnimation];
                [_germs addObject:germ];
            }
        }
    }
}

-(void) update:(ccTime)delta withMapXrange:(MapXRange) mapXRange;
{
    
    if (_germs.count < 1) {
        if (!endPanelAdded)
        {
            [ControlCenter player].visible = NO;
            EndGameLayer* endGameLayer = (EndGameLayer*)[CCBReader nodeGraphFromFile:@"EndUI.ccbi"];
            //        [endGameLayer setPosition:CENTER];
            [endGameLayer setScore:[[ControlCenter germManager] getScore] setKillNum:[[ControlCenter germManager] getKillNum]];
            
            [[GamePlayScene popLayer] addChild:endGameLayer];
            endPanelAdded = true;
            [[GamePlayScene controlLayer] setControlEnable:NO];
        }
    }
    
    for(int i=0;i<_germs.count;i++)
    {
        Germ *germ = [_germs objectAtIndex:i];
        if (germ.health > 0) {
            
//            if (fabs(germ.position.x - _player.position.x) < germ.awakeDistance && ![germ isAwake])
//            {
//                [germ setAwake:YES];
//
//            }
//            
//            if ([germ isAwake]) {
////                [germ updatePosition:delta towards:_player];
//                [germ update:delta];
////                [_player dealWithGerm:germ withMapXrange:(MapXRange) mapXRange];
////                [germ dealWithPlayer:_player];
//            }
            
            if ([germ isInScreen]) {
                if (![germ isAwake]) {
                    [germ setAwake:YES];
                }
                [germ update:delta];
            }
//            else
//            {
//                [germ setAwake:NO];
//            }

        }
        else
        {
            score++;
            killNum++;
            [WorldLayer world]->DestroyBody([germ body]);
            [_germs removeObject:germ];
        }

    }
}

-(void)handlePlayerAttack
{
//    int attackType = [[ControlCenter player] currentAttacType];
    
    
    
}

-(BOOL)isClear
{
//    NSLog(@"count === %d",[_germs count]);
//    return NO;
    return [_germs count] < 1;
}

-(BOOL)isCurrentSessionClear:(float)range
{
    for(int i=0;i<_germs.count;i++)
    {
        Germ *germ = [_germs objectAtIndex:i];
        if (germ.position.x < range)
        {
            return NO;
        }
    }
    return YES;
}

-(void)addRondomGerm:(int)count withMapXrange:(MapXRange) mapXRange
{
    for (int i=0; i<count; i++) {
        // Read class
        NSString* className = frandom_range(1,10)<10?@"Germ":@"LandGerm";
        
        Class germClass = NSClassFromString(className);
        
        Germ* germ = [[germClass alloc] init];
        
//        Germ *germ = [[Germ alloc] init];
        [_parent addChild:germ];
        germ.position = ccp(_player.position.x + frandom_range(0, min(mapXRange.right-_player.position.x, SCREEN.width)),_player.position.y + frandom_range(0, SCREEN.height));
    
        [germ setupBody];
//        [germ playStandByAnimation];
        [_germs addObject:germ];
    }
}

- (void)addGerm:(Germ *)germ position:(CGPoint)position
{
    [_parent addChild:germ];
    [germ setPosition:position];
    [germ setupBody];
    [_germs addObject:germ];
}

-(void)addRondomGerm:(int)count atPostion:(CGPoint)position
{
    for (int i=0; i<count; i++) {
        // Read class
        NSString* className = frandom_range(1,10)<8?@"Germ":@"LandGerm";
        
        Class germClass = NSClassFromString(className);
        
        Germ* germ = [[germClass alloc] init];
        
        //        Germ *germ = [[Germ alloc] init];
        [_parent addChild:germ];
        germ.position = position;
        
        [germ setupBody];
//        [germ playEnterAnimation];
        [_germs addObject:germ];
    }
}

-(int)getScore
{
    return score;
}

-(int)getKillNum
{
    return killNum;
}

-(void)dealWithBigAttack
{
    for(int i=0;i<_germs.count;i++)
    {
        Germ *germ = [_germs objectAtIndex:i];
        if ([germ isAwake]) {
            [germ dealWithBigAttack];
        }
    }
}

-(void)setAllActive:(BOOL)isActive
{
    for(int i=0;i<_germs.count;i++)
    {
        Germ *germ = [_germs objectAtIndex:i];
        [germ setActive:isActive];
    }
}

-(void)bombPlayed
{
    Player *player = [ControlCenter player];
    
    for(int i=0;i<_germs.count;i++)
    {
        Germ *germ = [_germs objectAtIndex:i];
        if ([germ isKindOfClass:[Boss class]]) {
            continue;
        }
        if (player.position.x > germ.position.x) {
            [germ hurtWithDamage:1000];
        }
    }

}

-(void)dealloc
{
    [super dealloc];
    instance_ = nil;
}

static GermManager *instance_ = nil;
+ (GermManager *) sharedGermManager
{
    if (!instance_) {
        instance_ = [[GermManager alloc] init];
    }
    return instance_;
}
@end
