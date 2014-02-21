//
//  EndGameLayer.h
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-17.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//


@interface EndGameLayer : CCLayer
{
    CCLabelTTF* scoreLabel;
    CCLabelTTF* killNumLabel;
}

-(void)setScore:(int)score setKillNum:(int)killNum;
@end
