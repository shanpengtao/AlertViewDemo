//
//  Utility.h
//  AlertViewDemo
//
//  Created by shanpengtao on 16/8/31.
//  Copyright © 2015年 shanpengtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - UIColor Category

@interface UIImage (privateImage)

+ (UIImage *)imageFromColor:(UIColor *)color;

@end

@interface UIColor (privateColor)

+ (UIColor *)colorWithString:(NSString *)colorValue;

+ (UIColor *)colorWithString:(NSString *)colorValue colorAlpha:(float)alpha;

@end