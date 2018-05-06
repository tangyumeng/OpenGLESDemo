//
//  Demo1TriangleViewController.m
//  OpenGLESDemo
//
//  Created by yumeng tang on 2018/5/6.
//  Copyright © 2018年 yumeng tang. All rights reserved.
//

#import "Demo1TriangleViewController.h"
#import "Demo1TriangleDemoView.h"

@interface Demo1TriangleViewController ()
@property (nonatomic,strong) Demo1TriangleDemoView *glView;
@end

@implementation Demo1TriangleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.glView = [[Demo1TriangleDemoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.glView];
}
@end
