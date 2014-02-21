//
//  GameModel.h
//  SuperGerm
//
//  Created by Ariequ on 14-1-27.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject
@property (nonatomic) int level;
+ (GameModel *) sharedGameModel;
@end
