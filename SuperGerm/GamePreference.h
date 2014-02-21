//
//  GamePreference.h
//  SuperGerm
//
//  Created by Ariequ on 14-2-7.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GamePreference : NSObject
+ (GamePreference *)sharedGamePreference;
- (void)updatePreference;
@property (nonatomic) BOOL backGroundMusicEnable;
@property (nonatomic) BOOL effectMusicEnable;
@end
