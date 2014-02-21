//
//  ShaderManager.m
//  SuperGerm
//
//  Created by Ariequ on 14-1-23.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "ShaderManager.h"

@implementation ShaderManager
{
    CCSprite *mySprite;
    int timeUniformLocation;
    float totalTime;
    CCGLProgram	*oringeShaderProgram;
}

- (void)addShaderTo:(CCSprite *)sprite
{
    mySprite = sprite;
    // 2
    CCFileUtils *fileUtils = [[[CCFileUtils alloc] init] autorelease];
    const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[fileUtils fullPathFromRelativePath:@"CSContact.fsh"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
    oringeShaderProgram = sprite.shaderProgram;
    sprite.shaderProgram = [[[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                      fragmentShaderByteArray:fragmentSource] autorelease];
    [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [sprite.shaderProgram link];
    [sprite.shaderProgram updateUniforms];
    
    // 3
    timeUniformLocation = glGetUniformLocation(sprite.shaderProgram->_program, "u_time");
    
    // 4
//    [self scheduleUpdate];
    
    // 5
    [sprite.shaderProgram use];
}

- (void)removeShader
{
    if (oringeShaderProgram) {
        mySprite.shaderProgram = oringeShaderProgram;
    }
    
//    [self unscheduleUpdate];
}

- (void) enableSprite:(CCSprite *)sp
{
    const GLchar* pszFragSource =
    "#ifdef GL_ES \n \
    precision mediump float; \n \
    #endif \n \
    uniform sampler2D u_texture; \n \
    varying vec2 v_texCoord; \n \
    varying vec4 v_fragmentColor; \n \
    void main(void) \n \
    { \n \
    // Convert to greyscale using NTSC weightings \n \
    vec4 col = texture2D(u_texture, v_texCoord); \n \
    gl_FragColor = vec4(col.r, col.g, col.b, col.a); \n \
    }";
    
     CCGLProgram* pProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureColor_vert
                               fragmentShaderByteArray:pszFragSource];
    sp.shaderProgram = pProgram;
    
    [sp.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [sp.shaderProgram addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
    [sp.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];

    [sp.shaderProgram link];
    [sp.shaderProgram updateUniforms];
}

- (void)update:(float)dt
{
    totalTime += dt;
    [mySprite.shaderProgram use];
    glUniform1f(timeUniformLocation, totalTime);
}

static ShaderManager *instance_ = nil;
+ (ShaderManager *) sharedShaderManager
{
    if (!instance_) {
        instance_ = [[ShaderManager alloc] init];
    }
    return instance_;
}


@end
