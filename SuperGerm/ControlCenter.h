//
//  ControlCenter.h
//  SuperGerm
//
//  Created by Ariequ on 14-1-5.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "WorldLayer.h"
#import "MapManager.h"
#import "GermManager.h"
@class GermManager;
@class WorldLayer;
@class MapManager;
@interface ControlCenter : NSObject
+(WorldLayer*)worldLayer;
+(MapManager*)mapManager;
+(GermManager*)germManager;
+(Player*)player;
@end
