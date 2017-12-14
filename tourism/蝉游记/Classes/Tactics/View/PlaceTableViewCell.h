//
//  PlaceTableViewCell.h
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlaceModel;

typedef void(^itemActionBlock)(NSInteger itemNO,PlaceModel *placeModel);
@interface PlaceTableViewCell : UITableViewCell
@property(nonatomic,strong)PlaceModel *placeModel;

@property(nonatomic,copy)itemActionBlock itemBlock;
@end
