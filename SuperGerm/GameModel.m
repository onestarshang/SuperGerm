//
//  GameModel.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-27.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel
static GameModel *instance_ = nil;
+ (GameModel *) sharedGameModel
{
    if (!instance_) {
        instance_ = [[GameModel alloc] init];
    }
    return instance_;
}

@end
