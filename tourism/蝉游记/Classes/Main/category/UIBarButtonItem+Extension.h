//
//  UIBarButtonItem+Extension.h
//  蝉游记
//
//  Created by Charles on 15/7/7.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action nomalImage:(UIImage *)nomalImage higeLightedImage:(UIImage *)higeLightedImage;


+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title image:(UIImage *)image;


@end
