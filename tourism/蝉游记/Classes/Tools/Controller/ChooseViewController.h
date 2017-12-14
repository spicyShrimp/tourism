//
//  ChooseViewController.h
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^chooseBlock)(NSString *title,NSString *language);
@interface ChooseViewController : UIViewController
@property(nonatomic,copy)chooseBlock block;
@end
