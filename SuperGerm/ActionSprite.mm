//
//  ActionSprite.m
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-20.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "ActionSprite.h"

@implementation ActionSprite
{
}

-(void)setPosition:(CGPoint)position {
    [super setPosition:position];
}

-(void)update:(ccTime)delta
{
    
}

-(void)setupBody
{
    
}

-(void) sythShapePosition
{
    b2Vec2 bodyPostion = _body->GetPosition();
    self.position = ccp(bodyPostion.x*PTM_RATIO,bodyPostion.y*PTM_RATIO);
    self.rotation = -_body->GetAngle()*180/3.14;
}

-(void) replaceBodyShape:(b2Body *)body withShapeName:(NSString*)shapeName
{
    b2Fixture *f;
    while((f = body->GetFixtureList()))
    {
//        if (f->GetFilterData().categoryBits == 1) {
            body->DestroyFixture(f);
//        }
    }
    
    if(shapeName)
    {
        GB2ShapeCache *shapeCache = [GB2ShapeCache sharedShapeCache];
        [shapeCache addFixturesToBody:body forShapeName:shapeName];
    }
}
@end
