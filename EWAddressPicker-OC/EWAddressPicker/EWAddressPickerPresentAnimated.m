//
//  EWAddressPickerPresentAnimated.m
//  EWAddressPicker-OC
//
//  Created by Ethan.Wang on 2018/9/14.
//  Copyright © 2018年 Ethan. All rights reserved.
//

#import "EWAddressPickerPresentAnimated.h"
#import "EWAddressViewController.h"

@implementation EWAddressPickerPresentAnimated

- (instancetype)initWithType:(enum EWAddressPickerPresentAnimateType)type{
        self = [super init];
        if (self) {
            self.type = type;
        }
    return self;
}

/**
 动画时间
 */
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    if (_type == present){
        EWAddressViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *toView = toVC.view;
        UIView *containerView = transitionContext.containerView;
        [containerView addSubview:toView];
        toVC.containV.transform = CGAffineTransformMakeTranslation(0, toVC.containV.frame.size.height);

        [UIView animateWithDuration:0.25 animations:^{
            /// 背景变色
            toVC.backgroundView.alpha = 1.0;
            /// addresspicker向上推出
            toVC.containV.transform = CGAffineTransformMakeTranslation(0, -10);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                /// transform初始化
                toVC.containV.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:true];
            }];
        }];
    }else {
        EWAddressViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        [UIView animateWithDuration:0.25 animations:^{
            toVC.backgroundView.alpha = 0.0;
            /// addresspicker向下推回
            toVC.containV.transform = CGAffineTransformMakeTranslation(0, toVC.containV.frame.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:true];
        }];
    }
}

@end
