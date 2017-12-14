//
//  JourneyModel.h
//  蝉游记
//
//  Created by charles on 15/7/19.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JourneyModel : NSObject
@property(nonatomic,strong)NSString *journeyId;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *attraction_type;
@property(nonatomic,strong)NSString *user_score;
@property(nonatomic,strong)NSString *name_en;
@property(nonatomic,strong)NSString *lat;
@property(nonatomic,strong)NSString *lng;
@end
