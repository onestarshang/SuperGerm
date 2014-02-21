#ifdef GL_ES
precision mediump float;
#endif
uniform sampler2D u_texture;
varying vec2 v_texCoord;
void main()
{
    //    float T = 2.0;
    float alpha = texture2D(u_texture, v_texCoord).a;
    vec2 st = v_texCoord.st;
    vec3 irgb = texture2D(u_texture, st).rgb;
    vec3 targetRgb = vec3(1.0,0.2,0.2);
    //    vec3 black = vec3(0., 0., 0.);
    //    gl_FragColor = vec4(mix(black, irgb, T), alpha);
    
    
//    float Contrast = 0.1;
//    float Brightness = 0.4;
//    
//    //    float alpha = texture2D(u_texture, v_texCoord).a;
//    
//    irgb.rgb /= alpha;
//    
//    // Apply contrast.
//    irgb.rgb = ((irgb.rgb - 0.5) * Contrast) + 0.5;
//    
//    // Apply brightness.
//    irgb.rgb += Brightness;
//    
//    // Return final pixel color.
//    irgb.rgb *= alpha;
    
    gl_FragColor = vec4(targetRgb*irgb*2.0,alpha);
}