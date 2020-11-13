//
//  EWAddressModel.m
//  EWAddressPicker-OC
//
//  Created by Ethan.Wang on 2018/9/14.
//  Copyright © 2018年 Ethan. All rights reserved.
//

#import "EWAddressModel.h"
///总数据
@implementation EWCountryModel 
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self){
        NSArray *keyArray = dic.allKeys;
        NSArray *valueArray = dic.allValues;
        _countryDictionary = [NSMutableDictionary dictionary];
        _provincesArray = keyArray;
        for (int i = 0; i < keyArray.count; i++) {
            EWProvinceModel *provinceModel = [[EWProvinceModel alloc] initWithDic:valueArray[i]];
            [_countryDictionary setValue:provinceModel forKey:keyArray[i]];
        }
    }
    return self;
}
@end
///省份数据
@implementation EWProvinceModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self){
        NSArray *keyArray = dic.allKeys;
        NSArray *valueArray = dic.allValues;
        _provincesDictionary = [NSMutableDictionary dictionary];
        _cityArray = keyArray;
        for (int i = 0; i < keyArray.count; i++) {
            EWCityModel *cityModel = [[EWCityModel alloc] initWithArr:valueArray[i]];
            [_provincesDictionary setValue:cityModel forKey:keyArray[i]];
        }
    }
    return self;
}
@end

///城市数据
@implementation EWCityModel
- (instancetype)initWithArr:(NSArray *)arr{
    self = [super init];
    if (self){
        self.areaArray = arr;
    }
    return self;
}
@end
