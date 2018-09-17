//
//  EWAddressPickViewTableViewCell.m
//  EWAddressPicker-OC
//
//  Created by Ethan.Wang on 2018/9/14.
//  Copyright © 2018年 Ethan. All rights reserved.
//

#import "EWAddressPickViewTableViewCell.h"
///tableView通用Cell
@implementation EWAddressPickViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _label = [[UILabel alloc]initWithFrame: CGRectMake(42, 8, 200, 24)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [self addSubview:_label];
    }
    return self;
}
@end

///tableView的第一个Cell,"请选择"三个字
@implementation EWAddressPickViewFirstTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _label = [[UILabel alloc]initWithFrame: CGRectMake(24, 11.5, 350, 17)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self addSubview:_label];
    }
    return self;
}
@end
