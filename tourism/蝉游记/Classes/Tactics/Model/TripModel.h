//
//  TripModel.h
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripModel : NSObject
@property(nonatomic,strong)NSString *tripId;
@property(nonatomic,strong)NSString *plan_days_count;
@property(nonatomic,strong)NSString *plan_nodes_count;
@property(nonatomic,strong)NSString *image_url;
@property(nonatomic,strong)NSString *tripDesc;
@property(nonatomic,strong)NSString *name;
@end
