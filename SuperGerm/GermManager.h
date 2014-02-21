//
//  GermManager.h
//  SuperGerm
//
//  Created by Ariequ on 13-10-26.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

@class Player;
#import <Foundation/Foundation.h>
#import "WorldLayer.h"
#import "Player.h"

@interface GermManager : NSObject

@property (nonatomic,retain) CCArray *germs;
@property (nonatomic,retain) Player *player;

- (void) update:(ccTime) delta withMapXrange:(MapXRange) mapXRange;
- (GermManager *) initWithTileMap:(CCTMXTiledMap *)tileMap player:(Player *)player parent:(CCLayer *)parent;
- (void)addGermInTileMap:(CCTMXTiledMap *)tileMap;
- (void)addRondomGerm:(int)count atPostion:(CGPoint)position;
- (BOOL)isClear;
- (void)addRondomGerm:(int) count withMapXrange:(MapXRange) mapXRange;
- (void)initParent:(CCNode *)parent player:(Player *)player;
- (int)getScore;
- (int)getKillNum;
- (void)dealWithBigAttack;
- (void)setAllActive:(BOOL)isActive;
- (BOOL)isCurrentSessionClear:(float)range;
- (void)bombPlayed;
- (void)addGerm:(Germ *)germ position:(CGPoint)position;

+ (GermManager *) sharedGermManager;
@end
