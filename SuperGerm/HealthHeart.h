//
//  HealthHeart.h
//  SuperGerm
//
//  Created by Ariequ on 14-2-23.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "CCSprite.h"

@interface HealthHeart : CCSprite
- (instancetype)initWithTotalBlood:(int)totalBlood;
- (void)drawBlood:(float)blood;
@end
