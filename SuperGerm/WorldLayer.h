//
//  WorldLayer.h
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-12.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "cocos2d.h"
#import "Player.h"
#import "Germ.h"
#import "ControlLayer.h"
#import "CCBReader.h"
#import "GLES-Render.h"
#import "MyContactListener.h"
#import "GB2Engine.h"
#import "GermManager.h"
#import "MapElement.h"

@interface WorldLayer : CCLayer 
{

}
@property (nonatomic,strong) CCSprite *background;
@property (nonatomic, strong) Player *player;
@property(nonatomic,strong)CCArray *germs;
@property(nonatomic,strong) MapElement *map;
@property (strong) CCTMXLayer *tileMapbackground;
@property (strong) CCTMXLayer *meta;
@property (nonatomic) int level;

- (void) moveAndFocusOnPlayer:(CGPoint) offset;
- (void) update:(ccTime)delta;
- (int)getScore;
- (int)getCoinCount;
- (void)resetRevivePanleAdded;
- (void)initializeWithLevel:(int)level;
- (void)scaleSmoothlyTo:(float)scale time:(float)time;
-(MapXRange)getMapXrange;
+(b2World *) world;
+ (WorldLayer *) sharedWorldLayer;
@end
