//
//  LoginViewController.h
//  蝉游记
//
//  Created by Charles on 15/7/20.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountModel;
typedef void(^loginBlock)(AccountModel *model);
@interface LoginViewController : UIViewController
@property(nonatomic,copy)loginBlock block;
@end
