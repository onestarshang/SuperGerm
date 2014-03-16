//
//  AnimationWapper.h
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-6.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AnimationWapper : NSObject
@property (nonatomic,retain) id target;
@property (nonatomic) SEL callback;
- (CCAction *)actionWithName:(NSString *)name frame:(int)frame target:(id) target callback:(SEL)callback;
- (CCAction *)actionWithPrefix:(NSString *)prefix suffix:(NSString*)suffix frame:(int)frame target:(id) target callback:(SEL)callback;
- (CCAction *)actionWithPrefix:(NSString *)prefix suffix:(NSString*)suffix frame:(int)frame frameDelay:(float)delay target:(id) target callback:(SEL)callback;
@end
