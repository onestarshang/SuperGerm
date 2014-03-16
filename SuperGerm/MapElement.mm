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
#import "Prop.h"

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
        
        [self addFloor];
        [self addPlayer];
        
        [self addElement];
    }
    return self;
}

- (void)addElement
{
    for (CCTMXObjectGroup* objectGroup in [_tileMap objectGroups])
    {
        for( id object in [objectGroup objects] )
        {
            int x = [object[@"x"] integerValue];
            int y = [object[@"y"] integerValue];
            CGPoint position = ccp((x + _tileMap.tileSize.width/2)/2, (y + _tileMap.tileSize.height/2)/2);
            NSString* groupName = [objectGroup groupName];
            Class groupClass = NSClassFromString(groupName);
            NSObject* obj = [[[groupClass alloc] init] autorelease];
            if ([obj isKindOfClass:[Germ class]])
            {
                [[GermManager sharedGermManager] addGerm:obj atPosition:position];
            }
            else if ([obj isKindOfClass:[Fence class]])
            {
                int tileGid = [object[@"gid"] integerValue];
                NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
                ((Fence *)obj).properties = properties;
                ((Fence *)obj).customProperties = object;
                [[FenceManager sharedFenceManager] addFence:obj atPosition:position];
            }
            else if([obj isKindOfClass:[Prop class]])
            {
                [[PropManager sharedPropManager] addProp:obj atPositon:position];
            }
            
        }
    }
}

- (void)addPlayer
{
    CCTMXObjectGroup* objectGroup = [_tileMap objectGroupNamed:@"Player"];
    
    id object = [[objectGroup objects] objectAtIndex:0];
    int x = [object[@"x"] integerValue];
    int y = [object[@"y"] integerValue];
    
    [ControlCenter player].position = ccp((x + _tileMap.tileSize.width/2)/2, (y + _tileMap.tileSize.height/2)/2);
    [[ControlCenter player] setPhysicPosition];
}

//- (NSArray *)megama
//{
//    if (!megama) {
//        megama = [[NSArray alloc] init];
//    }
//    return megama;
//}

-(void)addFloor
{
    floor = [_tileMap layerNamed:@"map1"];
    
    for(int col = 0; col < floor.layerSize.width; col++)
    {
        for (int raw = 0; raw < floor.layerSize.height; raw++)
        {
            int tileGid = [floor tileGIDAt:ccp(col, raw)];
            if (tileGid) {
                NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
                if (properties) {
                    NSString *isFloor = properties[@"floor"];
                    if (isFloor && [isFloor isEqualToString:@"true"])
                    {
                        [self addPhysicFloor:ccp(col, raw) withPhysicName:@"floor"];
                    }
                }
            }
        }
    }
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
@end
