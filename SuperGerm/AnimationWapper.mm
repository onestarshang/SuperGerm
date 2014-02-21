//
//  AnimationWapper.m
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-6.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "AnimationWapper.h"

@implementation AnimationWapper


-(void) localCallBack
{
    if ([_target respondsToSelector:_callback]) {
        [_target performSelector:_callback];
    }
}

//-(CCSprite *) addAnimation:(NSString *)actionName withFrameNum:(int)totalFrame atPosition:(CGPoint)postion inParent:(CCNode *)parent withPlistName:(NSString *)plistName withCallback:(SEL) callback target:(id) target
//{
//    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistName];
////    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"animation.png"];
////    [parent addChild:spriteSheet];
//    _target = target;
//    _callback = callback;
//    
//    NSMutableArray *walkAnimFrames = [NSMutableArray array];
//    for (int i=1; i<=totalFrame; i++) {
//        NSString *frameName;
//
//        if(i>=100)
//        {
//            frameName = [actionName stringByAppendingFormat:@"0%d",i];
//        }
//        else if(i>=10)
//        {
//            frameName = [actionName stringByAppendingFormat:@"00%d",i];
//        }
//        else
//        {
//            frameName = [actionName stringByAppendingFormat:@"000%d",i];
//        }
//
//        
//        [walkAnimFrames addObject:
//         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
//    }
//    
//    CCAnimation *walkAnim = [CCAnimation
//                             animationWithSpriteFrames:walkAnimFrames delay:0.05f ];
//    
//    CCSprite *displayBase = [CCSprite spriteWithSpriteFrameName:[actionName stringByAppendingString:@"0000"]];
//    
////    CCLOG(@"%f,%f",displayBase.contentSize.width,displayBase.contentSize.height);
////    CCLOG(@"%f",displayBase.anchorPoint.x);
//    
//    [displayBase setAnchorPoint:ccp(0,0)];
//    displayBase.position = postion;
//    
//    CCAction *walkAction = [CCSequence actions:[CCAnimate actionWithAnimation:walkAnim], [CCCallFunc actionWithTarget:self selector:@selector(localCallBack)],nil];
//    [displayBase runAction:walkAction];
//    
//    [parent addChild:displayBase];
//    
//    return displayBase;
// }
//
-(CCAction *)actionWithName:(NSString *)name frame:(int)frame target:(id) target callback:(SEL)callback
{
    _target = target;
    _callback = callback;
    
    NSMutableArray *animFrames = [[[NSMutableArray alloc] init] autorelease];
    for (int i=1; i<=frame; i++) {
        NSString *frameName;
        if(i>=100)
        {
            frameName = [name stringByAppendingFormat:@"0%d",i];
        }
        else if(i>=10)
        {
            frameName = [name stringByAppendingFormat:@"00%d",i];
        }
        else
        {
            frameName = [name stringByAppendingFormat:@"000%d",i];
        }
        [animFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:animFrames delay:0.05f];
    
    CCAction *walkAction = [CCSequence actions:[CCAnimate actionWithAnimation:walkAnim], [CCCallFunc actionWithTarget:self selector:@selector(localCallBack)],nil];
    
    
    return walkAction;
}

-(CCAction *)actionWithPrefix:(NSString *)prefix suffix:(NSString*)suffix frame:(int)frame frameDelay:(float)delay target:(id) target callback:(SEL)callback
{
    _target = target;
    _callback = callback;
    
    NSMutableArray *animFrames = [[[NSMutableArray alloc] init] autorelease];
    for (int i=1; i<=frame; i++) {
        NSString *frameName;
        frameName = [[prefix stringByAppendingString:[NSString stringWithFormat:@"%d", i]] stringByAppendingString:suffix];
        [animFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:animFrames delay:delay];
    
    CCAction *walkAction = [CCSequence actions:[CCAnimate actionWithAnimation:walkAnim], [CCCallFunc actionWithTarget:self selector:@selector(localCallBack)],nil];
    
    
    return walkAction;
}

-(CCAction *)actionWithPrefix:(NSString *)prefix suffix:(NSString*)suffix frame:(int)frame target:(id) target callback:(SEL)callback
{
    return [self actionWithPrefix:prefix suffix:suffix frame:frame frameDelay:0.05 target:target callback:callback];
}

@end
