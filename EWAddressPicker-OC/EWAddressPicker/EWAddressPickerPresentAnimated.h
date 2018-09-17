//
//  EWAddressPickerPresentAnimated.h
//  EWAddressPicker-OC
//
//  Created by Ethan.Wang on 2018/9/14.
//  Copyright © 2018年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//转场动画type
enum EWAddressPickerPresentAnimateType: NSUInteger {
    present, 
    dismiss,
};
//EWAddressPickerViewController的推出和取消动画
@interface EWAddressPickerPresentAnimated : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic,assign) enum EWAddressPickerPresentAnimateType type;

/**
 重写init方法,为其赋值type来区分是present还是dissmiss
 */
-(instancetype)initWithType:(enum EWAddressPickerPresentAnimateType)type;
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
@end
