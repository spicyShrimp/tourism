//
//  PlaceInfoModel.h
//  蝉游记
//
//  Created by Charles on 15/7/13.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceInfoModel : NSObject
@property(nonatomic,strong)NSString *temp_min;
@property(nonatomic,strong)NSString *temp_max;
@property(nonatomic,strong)NSString *current_time;
@property(nonatomic,strong)NSString *language_code;
@property(nonatomic,strong)NSString *currency_code;
@property(nonatomic,strong)NSString *currency_display;
@property(nonatomic,strong)NSString *country_name;
@end
