//
//  Utility.m
//  AlertViewDemo
//
//  Created by shanpengtao on 16/8/31.
//  Copyright © 2015年 shanpengtao. All rights reserved.
//

#import "Utility.h"

@implementation UIImage(privateImage)

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImg;
}

@end

@implementation UIColor (privateColor)

+ (UIColor *)colorWithString:(NSString *)colorValue
{
    return [self colorWithString:colorValue colorAlpha:1];
}

+ (UIColor *)colorWithString:(NSString *)colorValue colorAlpha:(float)alpha{
    
    UIColor *color = [UIColor clearColor];
    
    if ([[colorValue substringToIndex:1] isEqualToString:@"#"]) {
        
        if ([colorValue length]==7) {
            NSRange range = NSMakeRange(1,2);
            NSString *strRed = [colorValue substringWithRange:range];
            
            range.location = 3;
            NSString *strGreen = [colorValue substringWithRange:range];
            
            range.location = 5;
            NSString *strBlue = [colorValue substringWithRange:range];
            
            
            float r = [self getIntegerFromString:strRed];
            float g = [self getIntegerFromString:strGreen];
            float b = [self getIntegerFromString:strBlue];
            
            color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:alpha];
        }
    }
    return color;
}

//十进制转十六进制
+ (int) getIntegerFromString:(NSString *)str
{
    int nValue = 0;
    for (int i = 0; i < [str length]; i++)
    {
        int nLetterValue = 0;
        
        if ([str characterAtIndex:i] >='0' && [str characterAtIndex:i] <='9') {
            nLetterValue += ([str characterAtIndex:i] - '0');
        }
        else{
            switch ([str characterAtIndex:i])
            {
                case 'a':case 'A':
                    nLetterValue = 10;break;
                case 'b':case 'B':
                    nLetterValue = 11;break;
                case 'c': case 'C':
                    nLetterValue = 12;break;
                case 'd':case 'D':
                    nLetterValue = 13;break;
                case 'e': case 'E':
                    nLetterValue = 14;break;
                case 'f': case 'F':
                    nLetterValue = 15;break;
                default:nLetterValue = '0';
            }
        }
        
        nValue = nValue * 16 + nLetterValue; //16进制
    }
    return nValue;
}

@end