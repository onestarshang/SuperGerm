//
//  AnimateLabel.m
//  SuperGerm
//
//  Created by Ariequ on 13-11-9.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "AnimateLabel.h"
#import "CCLabelBMFont.h"


@implementation AnimateLabel
{
    CCLabelBMFont *label;
}

- (void)actionCallBack:(id)sender
{
    [label removeFromParentAndCleanup:YES];

}

-(void)createBMLabelSting:(NSString *)content pistion:(CGPoint)position parent:(CCNode *)parent withDuration:(int)duration
{
    label = [CCLabelBMFont labelWithString:@"" fntFile:@"hittext.fnt"];
    [parent addChild:label];
    
//    [label stopAllActions];
    [label setPosition:position];
    [label setString:content];
    CCActionInterval *fade = [CCFadeOut actionWithDuration:duration];
    
    CCCallFunc *callback = [CCCallFunc actionWithTarget:self selector:@selector(actionCallBack:)];
    CCSequence *sequence = [CCSequence actionOne:fade two:callback];
    [label runAction:sequence];
}

//- (void)dealloc
//{
////        [super dealloc];
//}

@end
