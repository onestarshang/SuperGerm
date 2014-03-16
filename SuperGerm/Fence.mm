//
//  Fence.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-12.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "Fence.h"

@implementation Fence
{
    BOOL _awake;
}
-(void)start
{
    
}

-(BOOL)isAwake
{
    return _awake;
}

-(void)setAwake:(BOOL)awake
{
    _awake = awake;
}

- (BOOL)isInScreen
{
    CGPoint worldPoint = [self.parent convertToWorldSpace:self.position];
    BOOL xIn = worldPoint.x > -100 && worldPoint.x < SCREEN.width+100;
    BOOL yIn = worldPoint.y > -100 && worldPoint.y < SCREEN.height+100;
    return xIn && yIn;
}
@end
