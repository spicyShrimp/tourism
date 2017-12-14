//
//  RegionModel.h
//  蝉游记
//
//  Created by Charles on 15/7/10.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceModel.h"

@interface RegionModel : NSObject
@property(nonatomic,strong)NSString *category;
@property(nonatomic,strong)NSArray *destinations;
@end
