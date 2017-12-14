//
//  AddBookViewController.h
//  蝉游记
//
//  Created by Charles on 15/7/17.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^addBlock)(NSDictionary *dict);
@interface AddBookViewController : UIViewController
@property(nonatomic,copy)addBlock block;
@end
