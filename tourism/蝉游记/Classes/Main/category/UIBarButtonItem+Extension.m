//
//  UIBarButtonItem+Extension.m
//  蝉游记
//
//  Created by Charles on 15/7/7.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action nomalImage:(UIImage *)nomalImage higeLightedImage:(UIImage *)higeLightedImage{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:nomalImage forState:UIControlStateNormal];
    [button setBackgroundImage:higeLightedImage forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title image:(UIImage *)image{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    button.size = CGSizeMake(80, 40);
    button.imageEdgeInsets=UIEdgeInsetsMake(0, 50, 0, 0);
    button.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 30);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


@end
