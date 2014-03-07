//
//  GoldCoin.m
//  SuperGerm
//
//  Created by Ariequ on 14-3-7.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "GoldCoin.h"
#import "WorldLayer.h"

@implementation GoldCoin

- (instancetype)init
{
    self = [super initWithSpriteFrameName:@"goldCoin"];
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


@end
