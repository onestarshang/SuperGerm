//
//  MapLayer.m
//  SuperGerm
//
//  Created by Ariequ on 13-11-18.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "MapElement.h"
#import "GB2ShapeCache.h"
#import "Box2D.h"
#import "WorldLayer.h"
#import "GermManager.h"
#import "FireBall.h"
#import "ControlCenter.h"
#import "Rock.h"
#import "FenceManager.h"
#import "PropManager.h"

@implementation MapElement
{
    CCTMXLayer* floor;
    int _currentHeight;
    NSMutableArray* _bodys;
    NSMutableArray* _covers;
    BOOL _isMegma;
    b2Body* coverBody;
    NSArray *megama;
}

-(instancetype) initWithMapName:(NSString*)mapName withPositon:(CGPoint)position withHeight:(int)currentHeight
{
    if(self = [super init])
    {
        _bodys = [[NSMutableArray alloc] init];
        _covers = [[NSMutableArray alloc] init];
        _currentHeight = currentHeight;
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:mapName];
        [self addChild:self.tileMap];
        [self setPosition:position];
        
        [self addFloor2];
        [self addMegama];
        [self addGerm];
        [self addFence];
        [self addPlayer];
        [self addProp];
//        [self addBoss];
    }
    return self;
}

- (void)addProp
{
    [[PropManager sharedPropManager] addPropInTileMap:_tileMap];
}

- (void)addPlayer
{
    CCTMXObjectGroup* objectGroup = [_tileMap objectGroupNamed:@"Player"];
    
    id object = [[objectGroup objects] objectAtIndex:0];
    int x = [object[@"x"] integerValue];
    int y = [object[@"y"] integerValue];
    
    [ControlCenter player].position = ccp(x, y);
    [[ControlCenter player] setPhysicPosition];
}

- (NSArray *)megama
{
    if (!megama) {
        megama = [[NSArray alloc] init];
    }
    return megama;
}

-(void)addGerm
{
    [[GermManager sharedGermManager] addGermInTileMap:_tileMap];
}

-(void)addFence
{
    [[FenceManager sharedFenceManager] addFenceInTileMap:_tileMap];
}

- (void)addMegama
{
    CCTMXObjectGroup* objectGroup = [_tileMap objectGroupNamed:@"Megama"];
    for( id object in [objectGroup objects] )
    {
        int x = [object[@"x"] integerValue];
        int y = [object[@"y"] integerValue];
        
        CGPoint coord = [self tileCoordForPosition:ccp(x/2, y/2)];
        [self addMegmaAt:coord];
    }
}

-(void)addMegmaAt:(CGPoint)coord
{
//    NSDictionary *coordDic = @{@"x": coord.x,@"y": coord.y};
    
    CCSprite* megma = [CCSprite spriteWithSpriteFrameName:@"Megma/0.png"];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    NSString* name = @"Megma/";
    for (int i=0; i<=12; i++) {
        NSString *frameName = [name stringByAppendingFormat:@"%d.png",i];
        [animFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:animFrames delay:0.1f];
    
    CCAction *walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
    
    
    //    CCAction* megmaAction = [[AnimationWapper alloc] actionWithName:@"02__0" frame:12 target:self callback:@selector(megmaAnimationCallBack)];
    [self addChild:megma];
    [megma setAnchorPoint:ccp(0, 0)];
    CGPoint position = ccp(coord.x*_tileMap.tileSize.width/2,(_tileMap.mapSize.height-coord.y-1)*_tileMap.tileSize.height/2);
    [megma setPosition:position];
    [megma runAction:walkAction];
//    CGPoint coord = [self tileCoordForPosition:position];
    [self addPhysicFloor:coord withPhysicName:@"megma"];

}

-(void)addMegma:(int)currentMapHeight
{
    CCSprite* megma = [CCSprite spriteWithSpriteFrameName:@"Megma/0.png"];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    NSString* name = @"Megma/";
    for (int i=0; i<=12; i++) {
        NSString *frameName = [name stringByAppendingFormat:@"%d.png",i];
//        if (i<10)
//        {
//            frameName = [name stringByAppendingFormat:@"%d.png",i];
//        }
//        else
//        {
//            frameName = [name stringByAppendingFormat:@"%d.png",i];
//        }
        [animFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:animFrames delay:0.05f];
    
    CCAction *walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
    
    
    //    CCAction* megmaAction = [[AnimationWapper alloc] actionWithName:@"02__0" frame:12 target:self callback:@selector(megmaAnimationCallBack)];
    [self addChild:megma];
    [megma setAnchorPoint:ccp(0, 0)];
    [megma setPosition:ccp(0,(currentMapHeight-1)*49)];
    [megma runAction:walkAction];
    CGPoint coord = [self tileCoordForPosition:ccp(0, 49*currentMapHeight)];
    [self addPhysicFloor:ccp(coord.x, coord.y) withPhysicName:@"megma"];
    
//    [self addFireBall:ccp(self.position.x + _tileMap.tileSize.width/4, (currentMapHeight)*49)];
    
//    for (int addtion = currentMapHeight-2; addtion>=0; addtion--) {
//        CCSprite* addtionSprite = [CCSprite spriteWithSpriteFrameName:@"megmaBac.png"];
//        [self addChild:addtionSprite];
//        [addtionSprite setAnchorPoint:ccp(0, 0)];
//        [addtionSprite setPosition:ccp(0, 49*addtion)];
//    }
}

-(void)addFireBall:(CGPoint)position
{
    FireBall* fireBall = [[FireBall alloc] init];
    [[[ControlCenter mapManager] actionSpriteLayer] addChild:fireBall];
    [fireBall setPosition:position];
    [fireBall setupBody];
    [fireBall start];
}

-(void)addRock:(CGPoint)position
{
    Rock* rock = [[Rock alloc]init];
    [[[ControlCenter mapManager] actionSpriteLayer] addChild:rock];
    [rock setPosition:position];
    [rock setupBody];
    [rock start];
}

-(void)addFloor2
{
    floor = [_tileMap layerNamed:@"map1"];
    
    for(int col = 0; col < floor.layerSize.width; col++)
    {
//        BOOL megmaAdded = NO;
        for (int raw = 0; raw < floor.layerSize.height; raw++)
        {
            int tileGid = [floor tileGIDAt:ccp(col, raw)];
            if (tileGid) {
                NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
                if (properties) {
                    NSString *isFloor = properties[@"floor"];
                    NSString* isMegma = properties[@"megma"];
                    if (isFloor && [isFloor isEqualToString:@"true"])
                    {
                        [self addPhysicFloor:ccp(col, raw) withPhysicName:@"floor"];
                    }
                    else if(isMegma && [isMegma isEqualToString:@"true"])
                    {
                        [self addPhysicFloor:ccp(col, raw) withPhysicName:@"megma"];
//                        if (!megmaAdded) {
//                            [self addMegmaAt:ccp(col,raw-1)];
//                            megmaAdded = YES;
//                        }
                    }
                    
                }
            }
        }
    }
    
//    [self addRock:ccp(self.position.x + _tileMap.tileSize.width/4, 100*4)];
}

-(b2Body*)addPhysicFloor:(CGPoint)coord withPhysicName:(NSString*)name
{
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_staticBody;
    ballBodyDef.position.Set((self.position.x + [self positionForTileCoord:coord].x/2)/(PTM_RATIO),(self.position.y + [self positionForTileCoord:coord].y/2)/(PTM_RATIO));
    ballBodyDef.userData = self;
    b2Body* _body =  WorldLayer.world->CreateBody(&ballBodyDef);
    
    b2Fixture *f;
    while((f = _body->GetFixtureList()))
    {
        _body->DestroyFixture(f);
    }
    
    GB2ShapeCache *shapeCache = [GB2ShapeCache sharedShapeCache];
    [shapeCache addFixturesToBody:_body forShapeName:name];

    [_bodys addObject:[NSValue valueWithPointer:_body]];
    
    return _body;
}

-(CGSize)size
{
    return CGSizeMake((_tileMap.mapSize.width)*(_tileMap.tileSize.width/2), (_tileMap.mapSize.height)*(_tileMap.tileSize.height/2));
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / (_tileMap.tileSize.width / 2);
    int y = _tileMap.mapSize.height - 1 -  (int)(position.y/(_tileMap.tileSize.height/2));
    return ccp(x, y);
}

- (CGPoint)positionForTileCoord:(CGPoint)coord {
    return ccp(_tileMap.tileSize.width*coord.x,(_tileMap.mapSize.height - coord.y -1)*_tileMap.tileSize.height);
}

-(void)cleanSelf
{
    for (NSValue* bobyValue in _bodys) {
        b2Body* body = (b2Body*)[bobyValue pointerValue];
        body->SetAwake(NO);
    }
    
    [self removeFromParentAndCleanup:YES];
}

-(void)coverMegma:(BOOL)isCover
{
    CCTMXObjectGroup* objectGroup = [_tileMap objectGroupNamed:@"Megama"];
    
    if (isCover) {
        for( id object in [objectGroup objects] )
        {
            int x = [object[@"x"] integerValue];
            int y = [object[@"y"] integerValue];
            
            CGPoint coord = [self tileCoordForPosition:ccp(x/2, y/2)];
            
            coverBody = [self addPhysicFloor:ccp(coord.x, coord.y) withPhysicName:@"floor"];
            [_covers addObject:[NSValue valueWithPointer:coverBody]];
        }
    }
    else
    {
        for (NSValue* bobyValue in _covers) {
            b2Body* body = (b2Body*)[bobyValue pointerValue];
            if (body) {
                [WorldLayer world]->DestroyBody(body);
            }
        }
        
        [_covers removeAllObjects];
        
        for( id object in [objectGroup objects] )
        {
            int x = [object[@"x"] integerValue];
            int y = [object[@"y"] integerValue];
            
            CGPoint coord = [self tileCoordForPosition:ccp(x/2, y/2)];
            
            [self addPhysicFloor:ccp(coord.x, coord.y) withPhysicName:@"megma"];
        }
        
    }
}

@end
