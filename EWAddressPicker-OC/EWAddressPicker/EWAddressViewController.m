//
//  EWAddressViewController.m
//  EWAddressPicker-OC
//
//  Created by Ethan.Wang on 2018/9/14.
//  Copyright © 2018年 Ethan. All rights reserved.
//

#import "EWAddressViewController.h"
#import "EWAddressPickerPresentAnimated.h"

@interface EWAddressViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation EWAddressViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawMyView];
}
- (void)drawMyView{
    [self.view insertSubview:self.backgroundView atIndex:0];
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    //viewcontroller弹出后之前控制器页面不隐藏 .custom代表自定义
    self.modalTransitionStyle = UIModalPresentationCustom;
    ///选中颜色,修改其可以修改titleSV中button和下划线的颜色
    UIColor *selectColor = [UIColor colorWithRed:79/255.0 green:176/255.0 blue:255.0/255.0 alpha:1];
    _containV = [[EWAddressPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 550, [UIScreen mainScreen].bounds.size.width, 550) selectColor:selectColor];
    ///弱引用,防止循环引用
    __weak typeof(self) weakSelf = self;
    _containV.backOnClickCancel = ^{
        [weakSelf onClickCancel];
    };
    _containV.backLocationString = ^(NSString *address, NSString *province, NSString *city, NSString *area) {
        ///闭包回调
        weakSelf.backLocationString(address, province, city, area);
        [weakSelf onClickCancel];
    };
    [self.view addSubview:_containV];
    // 转场动画代理
    self.transitioningDelegate = self;
}
///点击退出事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    CGPoint currentPoint = [[touches allObjects][0] locationInView:self.view];
    CGRect rect = self.containV.frame;
    if (!CGRectContainsPoint(rect, currentPoint)){
        [self dismissViewControllerAnimated:true completion:nil];
    }
}
- (void)onClickCancel{
    [self dismissViewControllerAnimated:true completion:nil];
}

///推入动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    EWAddressPickerPresentAnimated *animated = [[EWAddressPickerPresentAnimated alloc] initWithType:present];
    return animated;
}
///推出动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    EWAddressPickerPresentAnimated *animated = [[EWAddressPickerPresentAnimated alloc] initWithType:dismiss];
    return animated;
}


@end
