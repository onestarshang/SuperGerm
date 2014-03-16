//
//  PropManager.h
//  SuperGerm
//
//  Created by Ariequ on 14-3-7.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropManager : NSObject
+ (PropManager *) sharedPropManager;
- (int)getCoinCount;
- (void)addCoin;
- (void)addProp:(id)obj atPositon:(CGPoint)position;
@end
