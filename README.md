# EWAddressPicker-OC
<h3>OC.地址选择器</h3>

# 前言:

原本为Swift版本[AddressPicker](https://github.com/WangLiquan/AddressPicker).,因为有朋友需要一个OC版本,所以将其改写.但是由于有段时间没用OC了,所以可能会出现优化问题,这里我还是建议参考Swift版本.另如果发现任何问题请向我反馈,我好及时修改,谢谢.

# 实现效果:
controller弹出时:半透明背景渐变展示.地址选择器从下方弹出.

地址选择器:以省份,城市,地区三级进行选择,数据来自本地plist文件.有12个热门城市供快速选择,选择错误可以回选.

选择地区时进行将数据回调到上一控制器,点击页面空白区域退出controller.

controller消失时:背景渐变消失,地址选择器向下退出.



<br>

![效果图预览](https://github.com/WangLiquan/EWAddressPicker/raw/master/images/demonstration.gif)

# 使用方法:
将EWAddressPicker文件夹拖入项目,调用时:
```
EWAddressViewController *VC = [[EWAddressViewController alloc]init];
///保证弹出viewController背景色为透明
self.definesPresentationContext = YES;
VC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
VC.backLocationString = ^(NSString *address, NSString *province, NSString *city, NSString *area) {
// 返回选择数据,地址,省,市,区
    _showLabel.text = address;
};
[self presentViewController:VC animated:true completion:nil];
```
