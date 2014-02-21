//
//  ShaderManager.h
//  SuperGerm
//
//  Created by Ariequ on 14-1-23.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShaderManager : NSObject
+ (ShaderManager *) sharedShaderManager;
- (void)addShaderTo:(CCSprite *)sprite;
- (void)removeShader;
- (void) enableSprite:(CCSprite *)sp;
@end

