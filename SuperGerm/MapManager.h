//
//  Map.h
//  SuperGerm
//
//  Created by Ariequ on 13-11-19.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "CCSprite.h"
#import "Box2D.h"
#import "Player.h"
@class Player;

@interface MapManager : CCSprite
@property (nonatomic)CGPoint leftDownEdge;
@property (nonatomic)CGPoint rightUpEdge;
- (void)initWithMapLayer:(CCNode *)maplayer actionSpriteLayer:(CCNode*) actionSpriteLayer level:(int)level player:(Player*) player;
- (CGSize) mapSize;
- (MapXRange)mapXRange;
- (void)update:(ccTime)delta withWordPotion:(CGPoint)worldPostion;
- (int)getScore;
- (int)getKillNum;
- (CCNode*)actionSpriteLayer;
+ (MapManager*) sharedMapManager;
@end
