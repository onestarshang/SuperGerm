//
//  EndGameLayer.m
//  SuperGerm
//
//  Created by Ariequ on 13-12-25.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "EndGameLayer.h"
#import "GameStartScene.h"
#import "PaymentPanel.h"
#import "LevelLayer.h"

@implementation EndGameLayer
{
    int _score;
    int _killNum;
}

-(void)replayPressed:(id)sender
{
    [[GameKitHelper sharedGameKitHelper]
     submitScore:(int64_t)_score
     category:kHighScoreLeaderboardCategory];
    [[CCDirector sharedDirector] replaceScene:[LevelLayer scene]];
}

-(void)recoverPressed:(id)sender
{
    PaymentPanel* panel = [[PaymentPanel alloc] init];
    [self addChild:panel];
    [panel showAlerView];
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void) didLoadFromCCB
{
    [self setScore:_score setKillNum:_killNum];
}

-(void)setScore:(int)score setKillNum:(int)killNum
{
    _score = score;
    _killNum = killNum;
    if (scoreLabel) {
        [scoreLabel setString:[NSString stringWithFormat:@"%d",score]];
    }
    if (killNumLabel) {
        [killNumLabel setString:[NSString stringWithFormat:@"%d",killNum]];
    }
}
@end
