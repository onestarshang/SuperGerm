//
//  ControlLayer.h
//  IphoneAnimation
//
//  Created by Ariequ on 13-10-7.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "cocos2d.h"
#import "CCJoyStick.h"

@class ControlLayer;

@protocol SimpleDPadDelegate <NSObject>
-(void) controlCallBack:(int) tag isBegin:(BOOL) isBegin;
-(void) buttonCallBack:(int)tag power:(float)power;
@end

@interface ControlLayer : CCLayer<CCJoyStickDelegate>
@property(nonatomic,strong)id <SimpleDPadDelegate> delegate;
- (void)setControlEnable:(BOOL)enable;
- (void)updateHitProgress:(float)progress;
@end
