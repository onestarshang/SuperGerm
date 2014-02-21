//
//  HudLayer.h
//  SuperGerm
//
//  Created by Ariequ on 13-11-7.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "CCLayer.h"

@interface HudLayer : CCLayer
-(void)updateHealthPercent:(float)percent;
-(void)updateScore:(int)score;
@end
