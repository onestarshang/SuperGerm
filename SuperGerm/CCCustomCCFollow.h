//
//  CCCustomCCFollow.h
//  SuperGerm
//
//  Created by Ariequ on 14-3-1.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "CCAction.h"

@interface CCCustomCCFollow : CCFollow
{
    CGPoint currentPos;
	CGPoint previousTargetPos;
	BOOL isCurrentPosValid;
}

+(id) actionWithTarget:(CCNode *)followedNode worldBoundary:(CGRect)rect worldScale:(float)s;

@end