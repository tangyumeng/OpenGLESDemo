//
//  Demo1TriangleDemo.m
//  OpenGLESDemo
//
//  Created by yumeng tang on 2018/5/6.
//  Copyright © 2018年 yumeng tang. All rights reserved.
//

#import "Demo1TriangleDemoView.h"
#import "GLESUtils.h"


@implementation Demo1TriangleDemoView

+ (Class)layerClass {
    //OpenGL ES 需要自定义UIView 子类重写该方法，来支持在view 上面绘制 OpenGL 内容
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupProgram];
    }
    return self;
}


#pragma mark - utils methods
- (void)setupLayer
{
    
    //如果在viewController中，_eaglLayer = [CAEAGLLayer layer];[self.view.layer addSublayer:_eaglLayer];
    //如果在view中，可以直接重写UIView的layerClass类方法即可return [CAEAGLLayer class]。
    _eaglLayer = (CAEAGLLayer*) self.layer;
    
    // CALayer opaque 默认是NO(透明)，将它设为不透明才能让其可见
    _eaglLayer.opaque = YES;
    // 描绘属性：这里不维持渲染内容 颜色格式为 RGBA8
    // kEAGLDrawablePropertyRetainedBacking:若为YES，则使用glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)计算得到的最终结果颜色的透明度会考虑目标颜色的透明度值。
    // 若为NO，则不考虑目标颜色的透明度值，将其当做1来处理。
    // 使用场景：目标颜色为非透明，源颜色有透明度，若设为YES，则使用glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)得到的结果颜色会有一定的透明度（与实际不符）。若未NO则不会（符合实际）。
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setupContext {
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to setCurrentContext");
        exit(1);
    }
}

- (void)setupBuffers
{
    glGenRenderbuffers(1, &_colorRenderBuffer);
    // 设置为当前 renderbuffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    // 为 color renderbuffer 分配存储空间
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    // 设置为当前 framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)destoryBuffers
{
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
    
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
}

- (void)setupProgram
{
    // Load shaders
    //
    NSString * vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"VertexShader"
                                                                  ofType:@"vsh"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader"
                                                                    ofType:@"fsh"];
    
    // Create program, attach shaders, compile and link program
    //
    _programHandle = [GLESUtils loadProgram:vertexShaderPath
                 withFragmentShaderFilepath:fragmentShaderPath];
    if (_programHandle == 0) {
        NSLog(@" >> Error: Failed to setup program.");
        return;
    }
    
    glUseProgram(_programHandle);
    
    // Get attribute slot from program
    //
    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
}

- (void)render
{
    glClearColor(0, 0, 0, 1.0); //https://www.zhihu.com/question/40783239 
    
//#define GL_DEPTH_BUFFER_BIT                              0x00000100
//#define GL_STENCIL_BUFFER_BIT                            0x00000400
//#define GL_COLOR_BUFFER_BIT                              0x00004000
//    参数三个可选值
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    // Setup viewport
    //
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    const GLfloat vertices[] = {
        -0.5f, -0.5f, 0.0, // lower left corner
        0.5f, -0.5f, 0.0, // lower right corner
        -0.5f,  0.5f, 0.0 }; // upper left corner
    
    
    // Load the vertex data
    //
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices );
    glEnableVertexAttribArray(_positionSlot);
    
    // Draw triangle
    //
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:_context];
    [self destoryBuffers];
    [self setupBuffers];
    [self render];
}
@end
