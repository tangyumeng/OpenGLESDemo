//
//  Demo2TriangleViewController.h
//  OpenGLESDemo
//
//  Created by yumeng tang on 2018/5/6.
//  Copyright © 2018年 yumeng tang. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface Demo2TriangleViewController : GLKViewController
{
    GLuint vertexBufferID;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@end
