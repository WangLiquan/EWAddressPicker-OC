//
//  EWAddressPickerView.m
//  EWAddressPicker-OC
//
//  Created by Ethan.Wang on 2018/9/14.
//  Copyright © 2018年 Ethan. All rights reserved.
//

#import "EWAddressPickerView.h"
#import "EWAddressModel.h"
#import "EWAddressPickViewTableViewCell.h"
///tableViewType 根据type来修改页面展示样式与数据
enum EWLocationPickViewTableViewType: NSUInteger {
    provinces, ///省份
    city,      ///城市
    area,      ///地区
};

@interface EWAddressPickerView()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel;
    UIButton *rightCancelButton;
    UILabel *leftLabel;
    UIView *tableViewHeaderView;
    UIScrollView *titleSV;
    UIView *underLine;
    UITableView *tableView;
}
@property (nonatomic,assign) enum EWLocationPickViewTableViewType type;
@property (nonatomic,strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic,strong) NSString *selectedProvince;
@property (nonatomic,strong) NSString *selectedCity;
@property (nonatomic,strong) NSString *selectedArea;
@property (nonatomic,strong) EWCountryModel *locationModel;
@property (nonatomic,strong) EWProvinceModel *provincesModel;
@property (nonatomic,strong) EWCityModel *cityModel;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSArray<NSString *> *hotCiryArray;


@end

@implementation EWAddressPickerView
///type的set方法
-(void)setType:(enum EWLocationPickViewTableViewType)type{
    _type = type;
    switch (type) {
        case provinces:
            ///省份模式下有热门城市headerView,没有titleScrollView
            tableView.tableHeaderView = tableViewHeaderView;
            tableView.frame = CGRectMake(0, 42, [UIScreen mainScreen].bounds.size.width, 458);
            titleSV.hidden = YES;
            leftLabel.hidden = YES;
            ///清空选择数据
            self.provincesModel = nil;
            self.selectedProvince = @"";
            self.selectedCity = @"";
            self.selectedArea = @"";
            self.cityModel = nil;
            ///修改titleScrollView中button的样式,已保证选择省份后有下划线滚动的动画效果
            for (UIButton *button in _buttonArray) {
                [button setTitle:@"请选择" forState: UIControlStateNormal];
                button.selected = NO;
                if (button.tag == 0){
                    button.selected = YES;
                }
            }
            underLine.center = CGPointMake(self.buttonArray[1].center.x, underLine.center.y);
            ///tableView加载省份数据
            self.dataArray = _locationModel.provincesArray;
            [tableView reloadData];
            break;
        case city:
        {
            ///城市模式下没有热门城市headerView,有titleScrollView
            tableView.tableHeaderView = [[UIView alloc]init];
            tableView.frame = CGRectMake(0, 136, [UIScreen mainScreen].bounds.size.width, 367);
            titleSV.hidden = NO;
            leftLabel.hidden = NO;
            ///保留选择省份,清空城市地区数据
            self.selectedCity = @"";
            self.selectedArea = @"";
            self.cityModel = nil;
            for (UIButton *button in _buttonArray) {
                button.selected = NO;
                if (button.tag != 0) {
                    [button setTitle:@"请选择" forState:UIControlStateNormal];
                }
                if (button.tag == 1) {
                    button.selected = YES;
                }
            }
            [UIView animateWithDuration:0.3 animations:^{
                underLine.center = CGPointMake(self.buttonArray[1].center.x, underLine.center.y);
            }];
            ///tableView加载城市数据
            self.dataArray = _provincesModel.cityArray;
            [tableView reloadData];
            break;
        }
        case area:
            tableView.tableHeaderView = [[UIView alloc]init];
            tableView.frame = CGRectMake(0, 136, [UIScreen mainScreen].bounds.size.width, 367);
            titleSV.hidden = NO;
            leftLabel.hidden = NO;
            for (UIButton *button in _buttonArray) {
                button.selected = NO;
                if (button.tag == 2){
                    button.selected = YES;
                }
            }
            [UIView animateWithDuration:0.3 animations:^{
                underLine.center = CGPointMake(self.buttonArray[2].center.x, underLine.center.y);
            }];
            self.dataArray = _cityModel.areaArray;
            [tableView reloadData];
            break;
    }
}
/**
 已选择省份Set方法,给titleScrollView中Button赋值

 @param selectedProvince 已选择省份
 */
-(void)setSelectedProvince:(NSString *)selectedProvince{
    _selectedProvince = selectedProvince;
    for (UIButton *button in _buttonArray) {
        if (button.tag == 0) {
            [button setTitle:selectedProvince forState:UIControlStateNormal];
        }
    }
}
/**
 已选择城市Set方法,给titleScrollView中Button赋值
 @param selectedCity 已选择城市
 */
- (void)setSelectedCity:(NSString *)selectedCity{
    _selectedCity = selectedCity;
    for (UIButton *button in _buttonArray) {
        if (button.tag == 1){
            [button setTitle:selectedCity forState:UIControlStateNormal];
        }
    }
}
///重写init方法,实现选中状态颜色可修改
- (instancetype)initWithFrame:(CGRect)frame selectColor:(UIColor *)selectColor{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectColor = selectColor;
        ///热门城市Array,可修改,但要修改对应方法.例如修改数量就要同是修改buildTitleScrollView方法.修改城市也要修改onClickHotCity方法
        self.hotCiryArray = @[@"北京",@"上海",@"广州",@"深圳",@"杭州",@"南京",@"苏州",@"天津",@"武汉",@"长沙",@"重庆",@"成都"];
        ///从文件中获取城市数据
        [self initLocationData];
        [self drawMyView];
        ///页面默认type是省份模式
        self.type = provinces;
    }
    return self;
}
- (void)drawMyView{
    self.backgroundColor = UIColor.whiteColor;
    [self buildTitleScrollView];
    [self drawTableView];
    titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width -100) / 2, 9, 100, 24)];
    titleLabel.textColor = [[UIColor alloc]initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    titleLabel.text = @"选择国家地区";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:titleLabel];

    rightCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightCancelButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 42, 11, 18, 18);
    [rightCancelButton setImage:[UIImage imageNamed:@"BaseVC_cancel"] forState:UIControlStateNormal];
    [rightCancelButton addTarget:self action:@selector(onClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightCancelButton];

    leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 43, 40, 18)];
    leftLabel.text = @"已选择";
    leftLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    leftLabel.font = [UIFont systemFontOfSize:12];
    leftLabel.hidden = YES;
    [self addSubview:leftLabel];
}

- (void)buildTitleScrollView{
    ///每次切换状态显示时重新init,保证动画正常显示
    if (titleSV != nil){
        [titleSV removeFromSuperview];
    }
    _buttonArray = [NSMutableArray array];
    titleSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 72, [UIScreen mainScreen].bounds.size.width, 44)];
    underLine = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 30, 2)];
    underLine.backgroundColor = _selectColor;
    for (int i = 0; i < 3; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(24 + i * ([UIScreen mainScreen].bounds.size.width - 47) / 3, 0, [UIScreen mainScreen].bounds.size.width / 3, 44);
        button.tag = i;
        if (i == 1){
            button.selected = YES;
            underLine.center = CGPointMake(button.center.x, 40);
        }
        ///为Button设定normal状态和selected状态
        [button setTitle:@"请选择" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:_selectColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button addTarget:self action:@selector(onClickTitleButton:) forControlEvents: UIControlEventTouchUpInside];
        [_buttonArray addObject:button];
        [titleSV addSubview:button];
        titleSV.showsVerticalScrollIndicator = NO;
        [titleSV addSubview:underLine];
        titleSV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 44);
        titleSV.hidden = YES;
        [self addSubview:titleSV];
    }
}
- (void)drawTableView{
    tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(24, 0, 50, 18)];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"热门城市";
    [tableViewHeaderView addSubview:label];
    for (int i = 0; i < 12; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(24 + 80 * (i % 4), 28 + 40 * (i / 4), 80, 40);
        [button setTitle:_hotCiryArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(onClickHotCity:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [tableViewHeaderView addSubview:button];
    }

    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, [UIScreen mainScreen].bounds.size.width, 458) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = tableViewHeaderView;
    [self addSubview:tableView];

}

/**
 从文件中获取城市数据
 */
- (void)initLocationData{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
    self.locationModel = [[EWCountryModel alloc]initWithDic:dic];
    self.dataArray = _locationModel.provincesArray;
}

/**
 点击右侧退出按钮调用退出回调
 */
- (void)onClickCancelButton{
    if (_backOnClickCancel){
        _backOnClickCancel();
    }
/**
 点击热门城市,将tag传给setHotCityData方法
 */
}
- (void)onClickHotCity:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self setHotCityData:@"北京市" city:@"北京市"];
            break;
        case 1:
            [self setHotCityData:@"上海市" city:@"上海市"];
            break;
        case 2:
            [self setHotCityData:@"广东省" city:@"广州市"];
            break;
        case 3:
            [self setHotCityData:@"广东省" city:@"深圳市"];
            break;
        case 4:
            [self setHotCityData:@"浙江省" city:@"杭州市"];
            break;
        case 5:
            [self setHotCityData:@"江苏省" city:@"南京市"];
            break;
        case 6:
            [self setHotCityData:@"江苏省" city:@"苏州市"];
            break;
        case 7:
            [self setHotCityData:@"天津市" city:@"天津市"];
            break;
        case 8:
            [self setHotCityData:@"湖北省" city:@"武汉市"];
            break;
        case 9:
            [self setHotCityData:@"湖南省" city:@"长沙市"];
            break;
        case 10:
            [self setHotCityData:@"重庆市" city:@"重庆市"];
            break;
        case 11:
            [self setHotCityData:@"四川省" city:@"成都市"];
            break;
        default:
            break;
    }
    self.type = area;
/**
 点击热门城市后根据tag修改数据以及显示状态
 */
}
- (void)setHotCityData:(NSString *)province city:(NSString *)city{
    self.provincesModel = self.locationModel.countryDictionary[province];
    self.selectedProvince = province;
    self.cityModel = self.provincesModel.provincesDictionary[city];
    self.selectedCity = city;
}

/**
 点击titleScrollView中button切换type

 @param sender titleScrollView中的Button
 */
- (void)onClickTitleButton:(UIButton *)sender{
    if (!sender.isSelected) {
        switch (sender.tag) {
            case 0:
                self.type = provinces;
                break;
            case 1:
                self.type = city;
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    static NSString *cellID2 =@"cellID2";
    if (indexPath.row == 0){
        EWAddressPickViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell){
            cell = [[EWAddressPickViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.label.text = @"请选择";
        return cell;
    }
    
    EWAddressPickViewFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
    if (!cell){
        cell = [[EWAddressPickViewFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
    }
    cell.label.text = self.dataArray[indexPath.row - 1];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        switch (_type) {
            case provinces:
                ///为属性赋值,保证调用set方法,同时修改type与tableView数据源
                self.selectedProvince = self.locationModel.provincesArray[indexPath.row - 1];
                self.provincesModel = self.locationModel.countryDictionary[_selectedProvince];
                self.type = city;
                break;
            case city:
                ///为属性赋值,保证调用set方法,同时修改type与tableView数据源
                self.selectedCity = self.provincesModel.cityArray[indexPath.row - 1];
                self.cityModel = self.provincesModel.provincesDictionary[_selectedCity];
                self.type = area;
                break;
            case area:
            {
                self.selectedArea = self.dataArray[indexPath.row - 1];
                NSString *selectLocation = [NSString stringWithFormat:@"%@ %@ %@",_selectedProvince,_selectedCity,_selectedArea];
                if (_backLocationString){
                    ///将选中数据回调.
        _backLocationString(selectLocation,_selectedProvince,_selectedCity,_selectedArea);
                }

                break;
            }
            default:
                break;
        }
    }
}

@end

