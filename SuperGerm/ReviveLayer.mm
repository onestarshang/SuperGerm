
//
//  ReviveLayer.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-21.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "ReviveLayer.h"
#import "ControlCenter.h"

@implementation ReviveLayer
-(void)revivePressed:(id)sender
{
    [ControlCenter player].health = 3;
    
//    CGPoint safePosition = [[ControlCenter mapManager] nearestSafePosition];
    
//    [[ControlCenter player] body]->SetTransform(b2Vec2(safePosition.x/PTM_RATIO, safePosition.y/PTM_RATIO), 0);

    [[ControlCenter player] playBodyBomb];
    [self removeFromParentAndCleanup:YES];
    
    [[ControlCenter worldLayer] resetRevivePanleAdded];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)onEnter
{
    [super onEnter];
    [self registerWithTouchDispatcher];
}

- (void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];

}

-(void) registerWithTouchDispatcher
{
//    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kCCMenuHandlerPriority swallowsTouches:YES];
}
@end
