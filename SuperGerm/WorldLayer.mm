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

@implementation WorldLayer
{
    GLESDebugDraw *_debugDraw;
    GB2WorldContactListener *_contactListener;
    MapManager* mapManager;
    CCTMXTiledMap* _tileMap;
    CCLayer* mapLayer;
    CCLayer* actionSpriteLayer;
}

static b2World *_world;
-(id) init
{
    if (self = [super init])
    {
        [self initPhysics];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        mapLayer = [[CCLayer alloc] init];
        actionSpriteLayer = [[CCLayer alloc] init];
        
        [self addChild:mapLayer];
        [self addChild:actionSpriteLayer];
        
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animation.plist" ];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"HeroAnimaiton1.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"HeroAnimaiton2.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hero.plist" ];
        
        _player = [[Player alloc] init];
        _player.position = ccp(100, 20*16);//mapManager.mapSize.height);
        [_player setPhysicPosition];
        [actionSpriteLayer addChild:_player];
        
        mapManager = [MapManager sharedMapManager];
        
        [self setAnchorPoint:ccp(0, 0)];
        
//        [self addChild:[ShaderManager sharedShaderManager]];
//        [self setScale:2];
    }
    
    return self;
}

- (void)initializeWithLevel:(int)level
{
    [mapManager initWithMapLayer:mapLayer actionSpriteLayer:actionSpriteLayer level:level player:_player];
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
	
//	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
//	
//	kmGLPushMatrix();
//	
//	_world->DrawDebugData();
//	
//	kmGLPopMatrix();
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

    [self moveAndFocusOnPlayer:_player.position];
    
//    float range = 2000;
//    [self setScale:(range - _player.position.y)/range ];
    
//    NSLog(@"worldLayer scale %f",self.scale);
//    [self runAction:[CCFollow actionWithTarget:_player worldBoundary:CGRectMake(mapManager.leftDownEdge.x,mapManager.leftDownEdge.y,(mapManager.rightUpEdge.x-mapManager.leftDownEdge.x)*self.scaleX,(mapManager.rightUpEdge.y-mapManager.leftDownEdge.y))]];
    
    [[GermManager sharedGermManager] update:delta withMapXrange:mapManager.mapXRange];
    [[FenceManager sharedFenceManager] update:delta];
    
    [mapManager update:delta withWordPotion:self.position];
//    return;
    if (_player.health<=0) {
//        PaymentPanel* panel = [[PaymentPanel alloc] init];
//        [self addChild:panel];
//        [panel showAlerView];
//        [_player removeFromParentAndCleanup:YES];
        
        
        if (!revivePanleAdded) {
            ReviveLayer *reviveLayer = (ReviveLayer *)[CCBReader nodeGraphFromFile:@"reviveLayer.ccbi"];
            [[[CCDirector sharedDirector] runningScene] addChild:reviveLayer];
            revivePanleAdded = YES;
            return;
        }
        
    }
    else
    {
        if (_player.position.x > [mapManager mapSize].width - SCREEN.width/3) {
            

        }
    }
}

const int WORLD_MOVE_SPEED = 150;

- (void)setViewPointCenter:(CGPoint) position
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CGPoint actualPosition = position;
    CGPoint centerOfView = ccpMult(ccp(winSize.width/3, winSize.height/2),1/self.scale);
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
    
//    viewPoint = CGPointMake(viewPoint.x/0.8, viewPoint.y/0.8);
    // &&
//    if (fabs(viewPoint.x - self.position.x) > SCREEN.width*300)
//    {
////        [self stopAllActions];
//        if (([[[CCDirector sharedDirector] actionManager] numberOfRunningActionsInTarget:self] < 1)) {
//            CCAction* move = [CCMoveTo actionWithDuration:fabs(viewPoint.x - self.position.x)/WORLD_MOVE_SPEED position:viewPoint];
//            [self runAction:move];
//        }
//
//    }
//    else if([[[CCDirector sharedDirector] actionManager] numberOfRunningActionsInTarget:self] < 1)
//    {
//        self.position = viewPoint;
//    }
    
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
