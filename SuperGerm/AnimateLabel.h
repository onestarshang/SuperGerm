//
//  AnimateLabel.h
//  SuperGerm
//
//  Created by Ariequ on 13-11-9.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimateLabel : CCSprite
-(void)createBMLabelSting:(NSString *)content pistion:(CGPoint)position parent:(CCNode *)parent withDuration:(int)duration;
@end
