//
//  AreaLayer.m
//  SuperGerm
//
//  Created by Ariequ on 14-3-20.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "AreaLayer.h"
#import "CCScrollView.h"

@implementation AreaLayer
{
    CCScrollView *scrollView;
    CGPoint m_touchPoint;
    CGPoint m_touchOffset;
    int m_nCurPage;
    int m_nPageCount;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        m_nPageCount = 4;
        scrollView = [CCScrollView viewWithViewSize:[self contentSize]];
        [scrollView setTouchEnabled:NO];
        [scrollView setContainer:[self getContainerLayer]];
        [self addChild:scrollView];
        
        [self registerWithTouchDispatcher];
    }
    
    return self;
}

- (void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
     // 记录触摸起始点的位置
    m_touchPoint = [[CCDirector sharedDirector] convertTouchToGL:touch];
    // 记录触摸起始点的偏移
    m_touchOffset = [scrollView contentOffset];
    return true;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint movePoint = [[CCDirector sharedDirector] convertTouchToGL:touch]; // 获得当前的拖动距离
    
    float distance = movePoint.x - m_touchPoint.x;    // 设定当前偏移位置
    CGPoint adjustPoint = ccp(m_touchOffset.x + distance, 0);  // 让 scrollView 跟着 move 操作而移动
    [scrollView setContentOffset:adjustPoint animated:NO];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint endPoint = [[CCDirector sharedDirector] convertTouchToGL:touch];
    float distance = endPoint.x - m_touchPoint.x;
    
    if (fabs(distance) < 3){
        // 小于三，不做拖动操作，也排除了（抖动误操作）
    }else if (fabs(distance) > 50){
        // 大于 50，执行拖动效果
        [self adjustScrollView:distance];
    }else{
        // 回退为拖动之前的位置
        [self adjustScrollView:0];
    }
}

- (void)adjustScrollView:(float)offset
{
    // 我们根据 offset 的实际情况来判断移动效果
    if (offset < 0)     // 表示右移
        m_nCurPage ++;
    else if (offset > 0)
        m_nCurPage --;
    
    // 屏幕 页数 检测
    if (m_nCurPage < 0)
        m_nCurPage = 0;
    else if (m_nCurPage > m_nPageCount - 1)
        m_nCurPage = m_nPageCount - 1;
    
    // 根据当前的 页数 获得偏移量，并设定新的位置，且启用动画效果
    CGPoint adjustPoint = ccp(-330 * m_nCurPage , 0);
    [scrollView setContentOffset:adjustPoint animatedInDuration:0.2];
}

- (CCNode *)getContainerLayer
{
    CCLayer *layer = [[CCLayer alloc] init];
    
    for (int i = 0; i<4; i++) {
        CCSprite *level = [self getLevelSprite:i];
        float offSetX = SCREEN.width/2 + 330*i;
        float offSetY = SCREEN.height/2 + 50;
        
        [level setPosition:ccp(offSetX, offSetY)];
        
        [layer addChild:level];
    }
    
    return layer;
}

- (CCSprite *)getLevelSprite:(int)level
{
    NSString *backName;
    NSString *bannerName;
    NSString *buttonName;
    
    if (level < 1) {
        backName = @"areaAllow.png";
        buttonName = @"areaAllowButton.png";
    }
    else
    {
        backName = @"areaForbid.png";
        buttonName = @"areaForbidButton.png";
    }
    
    bannerName = [NSString stringWithFormat:@"areaBanner%d.png",level+1];
    
    CCSprite *ret = [[CCSprite alloc] init];
    
    CCSprite *back = [CCSprite spriteWithSpriteFrameName:backName];
    CCSprite *banner = [CCSprite spriteWithSpriteFrameName:bannerName];
    CCSprite *button = [CCSprite spriteWithSpriteFrameName:buttonName];
    
    [ret addChild:back];
    [ret addChild:banner];
    [ret addChild:button];
    [button setPosition:ccp(0, -60)];
    
    return ret;
}

@end
