//
//  ViewController.m
//  EWAddressPicker-OC
//
//  Created by Ethan.Wang on 2018/9/14.
//  Copyright © 2018年 Ethan. All rights reserved.
//

#import "ViewController.h"
#import "EWAddressModel.h"
#import "EWAddressViewController.h"
@interface ViewController ()

@property (strong,nonatomic) UILabel *showLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 450, [UIScreen mainScreen].bounds.size.width - 200, 50);
    [button setTitle:@"选择地址" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:255.0/255.0 green:51/255.0 blue:102/255.0 alpha:1] forState: UIControlStateNormal];
    [button addTarget:self action:@selector(onClickPresent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 250, [UIScreen mainScreen].bounds.size.width - 100, 50)];
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.adjustsFontSizeToFitWidth = true;
    _showLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:51/255.0 blue:102/255.0 alpha:1];
    [self.view addSubview:_showLabel];


}

- (void)onClickPresent{
    EWAddressViewController *VC = [[EWAddressViewController alloc]init];
    self.definesPresentationContext = YES;
    VC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    VC.backLocationString = ^(NSString *address, NSString *province, NSString *city, NSString *area) {
        _showLabel.text = address;
    };
    [self presentViewController:VC animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
