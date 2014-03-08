//
//  GoldCoin.m
//  SuperGerm
//
//  Created by Ariequ on 14-3-7.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "GoldCoin.h"
#import "WorldLayer.h"
#import "PropManager.h"
#import "SimpleAudioEngine.h"

@implementation GoldCoin

- (instancetype)init
{
    self = [super initWithSpriteFrameName:@"goldcoin.png"];
    if (self) {
    }
    
    return self;
}

-(void) setupBody
{
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_staticBody;
    ballBodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
    ballBodyDef.userData = self;
    _body = [WorldLayer world]->CreateBody(&ballBodyDef);
    [self replaceBodyShape:_body withShapeName:@"germ"];
}

- (void)removeSelf
{
    [self removeFromParentAndCleanup:YES];
    [WorldLayer world]->DestroyBody(_body);
    [[PropManager sharedPropManager] addCoin];
    [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];

}

-(void)beginContactWithPlayer:(GB2Contact *)contact
{
    NSString *fixtureId = (NSString *)contact.otherFixture->GetUserData();
    
    if ([fixtureId isEqualToString:@"hurtSensor"]) {
        [self scheduleOnce:@selector(removeSelf) delay:0.1];
    }
    
}



@end
