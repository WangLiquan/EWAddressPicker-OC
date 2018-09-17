//
//  EWAddressModel.h
//  EWAddressPicker-OC
//
//  Created by Ethan.Wang on 2018/9/14.
//  Copyright © 2018年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EWCountryModel : NSObject
@property (nonatomic,strong) NSMutableDictionary *countryDictionary;
@property (nonatomic,strong) NSArray *provincesArray;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

@interface EWProvinceModel : NSObject
@property (nonatomic,strong) NSMutableDictionary *provincesDictionary;
@property (nonatomic,strong) NSArray *cityArray;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

@interface EWCityModel : NSObject
@property (nonatomic,strong) NSArray *areaArray;

- (instancetype)initWithArr:(NSArray *)arr;
@end
