//
//  Fence.h
//  SuperGerm
//
//  Created by Ariequ on 14-1-12.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "ActionSprite.h"
#import "WorldLayer.h"
#import "ControlCenter.h"

@interface Fence : ActionSprite
-(void)start;
-(BOOL)isAwake;
-(void)setAwake:(BOOL)awake;
- (BOOL)isInScreen;
@end
