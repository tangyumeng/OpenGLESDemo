//
//  Demo1TriangleDemo.h
//  OpenGLESDemo
//
//  Created by yumeng tang on 2018/5/6.
//  Copyright © 2018年 yumeng tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Demo1TriangleDemoView : UIView{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    
    GLuint _programHandle;
    GLuint _positionSlot;
}
@end
