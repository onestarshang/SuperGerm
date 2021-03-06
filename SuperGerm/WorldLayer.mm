//
//  WorldLayer.m
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-12.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "WorldLayer.h"
#import "Germ.h"
#import "GLES-Render.h"
#import "GB2ShapeCache.h"
#import "GB2WorldContactListener.h"
#import "MapManager.h"
#import "Box2D.h"
#import "PaymentPanel.h"
#import "EndGameLayer.h"
#import "FenceManager.h"
#import "ReviveLayer.h"
#import "ShaderManager.h"
#import "LevelLayer.h"
#import "CCCustomCCFollow.h"
#import "PropManager.h"

@implementation WorldLayer
{
    GLESDebugDraw *_debugDraw;
    GB2WorldContactListener *_contactListener;
    MapManager* mapManager;
    CCTMXTiledMap* _tileMap;
    CCLayer* mapLayer;
    CCLayer* actionSpriteLayer;
    int lastPlayerDirection;
}

static b2World *_world;
-(id) init
{
    if (self = [super init])
    {
        [self initPhysics];
        
        mapLayer = [[CCLayer alloc] init];
        actionSpriteLayer = [[CCLayer alloc] init];
        CCLayer *playerLayer = [[CCLayer alloc] init];


        [self addChild:mapLayer];
        [self addChild:actionSpriteLayer];
        [self addChild:playerLayer];
        
        
        _player = [[Player alloc] init];
        [playerLayer addChild:_player];
        
        mapManager = [MapManager sharedMapManager];
        
        [self setAnchorPoint:ccp(0, 0)];
        
//        [self addChild:[ShaderManager sharedShaderManager]];
        [self setScale:0.8];
    }
    
    return self;
}

- (void)initializeWithLevel:(int)level
{
    [mapManager initWithMapLayer:mapLayer actionSpriteLayer:actionSpriteLayer level:level player:_player];
    [self moveAndFocusOnPlayer:_player.position];
    [self scheduleUpdate];
}

-(void)addWall
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(0,0);
    bodyDef.angle = 0;
    b2Body *body = _world->CreateBody(&bodyDef);
    
    b2EdgeShape edgeShape;
    edgeShape.Set(b2Vec2(0, 0),b2Vec2(0,1000));
    body->CreateFixture(&edgeShape,0);
}

-(void)initPhysics
{
    // load physics shapes
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"Physics.plist"];
    
    b2Vec2 gravity = b2Vec2(0.0f, -20.0f);
    _world = new b2World(gravity);
    _world->SetAllowSleeping(true);
    
    // Enable debug draw
    _debugDraw = new GLESDebugDraw( 32 );
    _world->SetDebugDraw(_debugDraw);
    
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
    _debugDraw->SetFlags(flags);
    
    // Create contact listener
    _contactListener = new GB2WorldContactListener();
    _world->SetContactListener(_contactListener);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];

    BOOL debugDraw = NO;
    if (debugDraw) {
        ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
        kmGLPushMatrix();
        _world->DrawDebugData();
        kmGLPopMatrix();
    }
}

- (void)scaleSmoothlyTo:(float)scale time:(float)time
{
    CCAction *scaleAction = [CCScaleTo actionWithDuration:time scale:scale];
    [self runAction:scaleAction];
}

-(void) setPlayerPosition:(CGPoint) position
{
    _player.position = position;
}

bool endPanelAdded = false;
bool revivePanleAdded = false;

-(void) update:(ccTime)delta
{
    _world->Step(delta,10,10);
    [_player update:delta];

//    [self moveAndFocusOnPlayer:_player.position]; 
    
//    float range = 2000;
//    [self setScale:(range - _player.position.y)/range ];
    
//    NSLog(@"worldLayer scale %f",self.scale);
//    [self runAction:[CCFollow actionWithTarget:_player worldBoundary:CGRectMake(mapManager.leftDownEdge.x,mapManager.leftDownEdge.y,(mapManager.rightUpEdge.x-mapManager.leftDownEdge.x)*self.scaleX,(mapManager.rightUpEdge.y-mapManager.leftDownEdge.y))]];
    
    [self stopAllActions];
    [self runAction:[CCCustomCCFollow actionWithTarget:_player worldBoundary:CGRectMake(0, 0, mapManager.mapSize.width,mapManager.mapSize.height) worldScale:self.scale]];
    
    [[GermManager sharedGermManager] update:delta withMapXrange:mapManager.mapXRange];
    [[FenceManager sharedFenceManager] update:delta];

    if (_player.health<=0)
    {
        if (!revivePanleAdded) {
            ReviveLayer *reviveLayer = (ReviveLayer *)[CCBReader nodeGraphFromFile:@"reviveLayer.ccbi"];
            [[[CCDirector sharedDirector] runningScene] addChild:reviveLayer];
            revivePanleAdded = YES;
            return;
        }
    }
}

//const int WORLD_MOVE_SPEED = 150;

- (void)setViewPointCenter:(CGPoint) position
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CGPoint actualPosition = position;
    CGPoint centerOfView = ccpMult(ccp(winSize.width/2, winSize.height/2),1/self.scale);
    
//    CGPoint centerOfView = ccpMult(ccp(winSize.width/2-[ControlCenter player].scaleX*winSize.width/5, winSize.height/3),1/self.scale);
    CGPoint viewPoint = ccpMult(ccpSub(centerOfView, actualPosition), self.scale);
    
    if (position.x < mapManager.leftDownEdge.x + centerOfView.x) {
        viewPoint.x = -mapManager.leftDownEdge.x;
    }

    if (position.y < mapManager.leftDownEdge.y + centerOfView.y) {
        viewPoint.y = -mapManager.leftDownEdge.y;
    }
    
    if (position.x > mapManager.rightUpEdge.x*self.scale - winSize.width + centerOfView.x) {
        viewPoint.x = self.scale*(-mapManager.rightUpEdge.x) + winSize.width;
    }
    
    if (position.y/self.scale > mapManager.rightUpEdge.y - winSize.height + centerOfView.y) {
        viewPoint.y = -mapManager.rightUpEdge.y*self.scale + winSize.height;
    }
    
    self.position = viewPoint;
}

-(void) moveAndFocusOnPlayer:(CGPoint) playerTargetPos
{
    if (playerTargetPos.x <= mapManager.mapSize.width &&
        playerTargetPos.y <= mapManager.mapSize.height &&
        playerTargetPos.y >= 0 &&
        playerTargetPos.x >= 0 )
    {
        [self setViewPointCenter:playerTargetPos];
    }
}

-(void)onEnter
{
    [super onEnter];
    [mapManager onEnter];
}

+(b2World *) world
{
    return _world;
}

-(int)getScore
{
    return [mapManager getScore];
}

- (int)getCoinCount
{
    return [[PropManager sharedPropManager] getCoinCount];
}

-(int)getKillNum
{
    return [mapManager getKillNum];
}

-(void)dealloc
{
    [super dealloc];
    [mapManager dealloc];
    [[GermManager sharedGermManager] dealloc];
    endPanelAdded = NO;
    revivePanleAdded = NO;
    _debugDraw = nil;
    _contactListener = nil;
    [_tileMap release];
    [mapLayer release];
    [actionSpriteLayer release];
    instance_ = nil;
}

-(MapXRange)getMapXrange
{
    return [mapManager mapXRange];
}

- (void)resetRevivePanleAdded
{
    revivePanleAdded = false;
}

static WorldLayer *instance_ = nil;
+ (WorldLayer *) sharedWorldLayer
{
    if (!instance_) {
        instance_ = [[WorldLayer alloc] init];
    }
    return instance_;
}

@end
