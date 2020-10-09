//
//  XZCServiceChoiceIconView.m
//  ERP-System
//
//  Created by xzc on 2018/12/27.
//  Copyright © 2018年 邵镭镭. All rights reserved.
//

#import "XZCServiceChoiceIconView.h"

@interface XZCServiceChoiceIconView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation XZCServiceChoiceIconView




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickModifyService)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePan:)];
        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (UIImageView *)imageView{
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc]init];
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        
        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        UIImage* image = [UIImage imageNamed:icon];

        if (icon == nil) {
            _imageView.backgroundColor = [UIColor redColor];
        }
        else{
            _imageView = [[UIImageView alloc]initWithImage:image];

        }
        _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    }
    return _imageView;
}

//- (void)setImageName:(NSString *)imageName{
//    _imageName = imageName;
//    _imageview.image = [UIImage imageNamed:imageName];
//}

- (void)clickModifyService{
    //    NSLog(@"clickModifyService");
    if (self.clickIconBlock) {
        self.clickIconBlock();
    }
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint translation = [recognizer translationInView:window.rootViewController.view];
    
    CGFloat translationX = recognizer.view.center.x + translation.x;
    CGFloat translationY = recognizer.view.center.y + translation.y;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    recognizer.view.center = CGPointMake((translationX > screenWidth ? screenWidth : translationX), (translationY > screenHeight ? screenHeight : translationY));
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x > 30 ? recognizer.view.center.x : 30, recognizer.view.center.y > 30?recognizer.view.center.y:30);
    
    //    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x > [UIScreen mainScreen].bounds.size.width - 30 ? [UIScreen mainScreen].bounds.size.width - 30:recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y > [UIScreen mainScreen].bounds.size.height - 30 ? [UIScreen mainScreen].bounds.size.height - 30: recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:window.rootViewController.view];
    
}


@end
