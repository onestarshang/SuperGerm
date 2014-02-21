//
//  Map.m
//  SuperGerm
//
//  Created by Ariequ on 13-11-19.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "MapManager.h"
#import "MapElement.h"
#import "WorldLayer.h"
#import "AnimateLabel.h"
#import "AnimationWapper.h"
#import "ControlCenter.h"
#import "GamePlayScene.h"

int tileSize = 100;

int mapSection[5] = {1800,2800,3300,4000,4500 };

@implementation MapManager
{
    CCNode* parent;
    NSMutableArray* elementArray;
    b2Body *leftWall;
    b2Body *rightWall;
    int currentSection;
    Player* _player;
    CCNode* _maplayer;
    CCNode* _actionSpriteLayer;
    int stage;
    int currentMapHeight;
    int maxMapHeight;
    int minMapHeight;
    int score;
    int lastMagma;
    CGSize _mapSize;
    int _level;
}

-(void)initWithMapLayer:(CCNode *)maplayer actionSpriteLayer:(CCNode*) actionSpriteLayer level:(int)level player:(Player *)player
{
    _level = level;
    currentMapHeight = 3;
    score = 0;
    lastMagma = -1;
    _player = player;
    _maplayer = maplayer;
    stage = 1;
    _actionSpriteLayer = actionSpriteLayer;

    elementArray = [[NSMutableArray alloc] init];
    maxMapHeight = 7;
    minMapHeight = 2;
    _mapSize = CGSizeMake(0, 0);
    
    [[GermManager sharedGermManager] initParent:actionSpriteLayer player:player];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Magma.plist" ];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fence.plist" ];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Boss.plist" ];
    
    [self addElement];
    
    currentSection = _mapSize.width;
    
    _leftDownEdge = ccp(0, 0);
    _rightUpEdge = ccp(currentSection, [self mapSize].height);
}

-(void)onEnter
{
    [super onEnter];
    [self addStageLabel];
}

-(CGSize)mapSize
{
//    float width = 0;
//    float height = 0;
//    for (int i=0; i<[elementArray count]; i++) {
//        width += ((MapElement*)[elementArray objectAtIndex:i]).size.width;
//        height += ((MapElement*)[elementArray objectAtIndex:i]).size.height;
//
//    }
    
    return _mapSize;
//    return CGSizeMake(width, height);
}

-(MapXRange)mapXRange
{
    MapXRange result;
    result.left = _leftDownEdge.x;
    result.right = _rightUpEdge.x;
    return result;
}

//static int sameOffset = 0;
-(void)addElement
{
//    NSLog(@"currentMapHeight %d",currentMapHeight);
//    NSString* mapName;
//    if (frandom< 0.9 && lastMagma != [elementArray count] && [elementArray count] > 5 && sameOffset == 1) {
//        mapName = @"tileMap/map0.tmx";
//        lastMagma = [elementArray count] +1;
////        [self addMegma];
//    }
//    else
//    {
//        int offset;
//        if (lastMagma == [elementArray count]) {
//            offset = 1;
//        }
//        else
//        {
//            if (sameOffset == 0) {
//                offset = 0;
//                sameOffset = 1;
//            }
//            else
//            {
//                sameOffset = 0;
//                offset = random_range(-1, 1);
//
//            }
//        }
//        
////        NSLog(@"offset %d",offset)
//        currentMapHeight = currentMapHeight + offset;
//        currentMapHeight = MIN(currentMapHeight, maxMapHeight);
//        currentMapHeight = MAX(currentMapHeight, minMapHeight);
//        mapName = [NSString stringWithFormat:@"map%d.tmx",currentMapHeight];
//    }
    
    NSString *mapName = [NSString stringWithFormat:@"level%d.tmx",_level];
    mapName = @"level5.tmx";
    
    MapElement* element = [[[MapElement alloc] initWithMapName:mapName withPositon:ccp([self mapSize].width, 0) withHeight:currentMapHeight] autorelease];
    _mapSize = CGSizeMake(_mapSize.width+element.size.width, max(_mapSize.height, element.size.height));
    [_maplayer addChild:element];
    [elementArray addObject:element];
}



int gapCount = 0;
-(void)update:(ccTime)delta withWordPotion:(CGPoint)worldPostion
{
    if ([[GermManager sharedGermManager] isCurrentSessionClear:_rightUpEdge.x]) {
        
        if (currentSection + 20*tileSize <= 80*tileSize) {
            currentSection+=20*tileSize;
            stage++;
            if (-worldPostion.x > _leftDownEdge.x) {
                _leftDownEdge.x = (int)(-worldPostion.x/tileSize)*tileSize;
            }
            _rightUpEdge = ccp(currentSection, [self mapSize].height);
            
            [self addStageLabel];
            
            NSMutableArray* deletElements = [[[NSMutableArray alloc] init] autorelease];
            for (MapElement* element in elementArray) {
                if (element.position.x + element.size.width< _leftDownEdge.x) {
                    [deletElements addObject:element];
                }
            }
            
            for (MapElement* element in deletElements) {
                [element cleanSelf];
            }
        }
        

    }
//    _player.position.x > [self mapSize].width - SCREEN.width && 
    
    if ([self mapSize].width < _rightUpEdge.x) {
        
        [self addElement];
    }
    
    [self updateWall];
}

-(void) addStageLabel
{
//    CGPoint labelPostion = ccpAdd(ccp(0,100), _player.position);
    CGPoint labelPostion = ccp(SCREEN.width/2,SCREEN.height/2);
    
    AnimateLabel *label = [[[AnimateLabel alloc] init] autorelease];
    [label createBMLabelSting:[NSString stringWithFormat:@"STAGE %d",stage] pistion:labelPostion parent:[GamePlayScene lebalLayer] withDuration:2];

}

-(void)updateWall
{
    if (!leftWall) {
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        bodyDef.position.Set(0,0);
        bodyDef.angle = 0;
        bodyDef.userData = self;
        leftWall = [WorldLayer world]->CreateBody(&bodyDef);
        
        GB2ShapeCache *shapeCache = [GB2ShapeCache sharedShapeCache];
        [shapeCache addFixturesToBody:leftWall forShapeName:@"wall"];

    }
    
    if (!rightWall) {
        b2BodyDef bodyDefRight;
        bodyDefRight.type = b2_staticBody;
        bodyDefRight.position.Set(0,0);
        bodyDefRight.angle = 0;
        bodyDefRight.userData = self;
        
        rightWall = [WorldLayer world]->CreateBody(&bodyDefRight);
        
        GB2ShapeCache *shapeCache = [GB2ShapeCache sharedShapeCache];
        [shapeCache addFixturesToBody:rightWall forShapeName:@"wall"];

    }
    
    leftWall->SetTransform(b2Vec2(_leftDownEdge.x/PTM_RATIO,0), 0);
    rightWall->SetTransform(b2Vec2(_rightUpEdge.x/PTM_RATIO,0), 0);
}

-(CGPoint)nearestSafePosition
{
    Player *player = [ControlCenter player];
    
    MapElement *map = [elementArray objectAtIndex:0];
    CCTMXTiledMap *tileMap = map.tileMap;
    CCTMXLayer *maplayer = [tileMap layerNamed:@"map1"];
    
    int tileX = player.position.x/(tileMap.tileSize.width/2);
    
    while ([self floorAt:tileX mapLayer:maplayer map:map].x < 0) {
        tileX++;
    }
    
    CGPoint safetile = [self floorAt:tileX mapLayer:maplayer map:map];
    return ccp((safetile.x +1)*tileMap.tileSize.width/2, (tileMap.mapSize.height - safetile.y + 1)*tileMap.tileSize.height/2);
    
}
    
-(CGPoint)floorAt:(int)tileX mapLayer:(CCTMXLayer *)maplayer map:(MapElement *)map
{
    CCTMXTiledMap *tileMap = map.tileMap;

    for (int raw = 0; raw < maplayer.layerSize.height; raw++)
    {
        int tileGid = [maplayer tileGIDAt:ccp(tileX, raw)];
        if (tileGid) {
            NSDictionary *properties = [tileMap propertiesForGID:tileGid];
            if (properties) {
                NSString *isFloor = properties[@"floor"];
                if (isFloor) {
                    return ccp(tileX, raw);
                }
            }
        }
    }
    return ccp(-1, -1);
}


-(int)getScore
{
    return [[GermManager sharedGermManager] getScore];
}

-(int)getKillNum
{
    return [[GermManager sharedGermManager] getKillNum];
}

-(void)coverAllMegma:(BOOL)isCover
{
    for (MapElement* element in elementArray) {
        [element coverMegma:isCover];
    }
}

-(CCNode*)actionSpriteLayer
{
    return _actionSpriteLayer;
}

-(void)dealloc
{
    [super dealloc];
    [elementArray dealloc];
    instance_ = nil;
}



static MapManager *instance_ = nil;
+ (MapManager *) sharedMapManager
{
    if (!instance_) {
        instance_ = [[MapManager alloc] init];
    }
    return instance_;
}

@end
