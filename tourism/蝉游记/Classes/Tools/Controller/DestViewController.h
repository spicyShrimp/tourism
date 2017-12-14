//
//  DestViewController.h
//  蝉游记
//
//  Created by Charles on 15/7/13.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlaceModel;

typedef void(^DestPlaceBlock)(PlaceModel *placeModel);
@interface DestViewController : UIViewController
@property(nonatomic,copy)DestPlaceBlock placeBlock;
@end
