//
//  Level.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-27.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "Level.h"
#import "GameModel.h"
#import "GameStartScene.h"

@implementation Level
- (void)menuSelect:(id)sender
{
    CCNode *node = (CCNode *)sender;
    int level = node.tag;
    
    [GameModel sharedGameModel].level = level;

    [[CCDirector sharedDirector] replaceScene:[[GameStartScene alloc] init]];
    
}
@end
