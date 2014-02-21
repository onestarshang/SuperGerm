//
//  MapLayer.h
//  SuperGerm
//
//  Created by Ariequ on 13-11-18.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "CCTMXTiledMap.h"

@interface MapElement : CCNode
-(instancetype) initWithMapName:(NSString*)mapName withPositon:(CGPoint)position withHeight:(int)currentHeight;
-(CGSize)size;
-(void)cleanSelf;
-(void)coverMegma:(BOOL)isCover;
@property (nonatomic,retain)CCTMXTiledMap* tileMap;
@end
