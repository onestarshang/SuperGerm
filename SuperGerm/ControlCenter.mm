//
//  ControlCenter.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-5.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "ControlCenter.h"

@implementation ControlCenter
+(WorldLayer*)worldLayer
{
    return [WorldLayer sharedWorldLayer];
}
+(MapManager*)mapManager
{
    return [MapManager sharedMapManager];
}
+(GermManager*)germManager
{
    return [GermManager sharedGermManager];
}

+(Player*)player
{
    return [[WorldLayer sharedWorldLayer] player];
}

@end
