//
//  Defines.h
//  AlertViewDemo
//
//  Created by shanpengtao on 16/8/31.
//  Copyright © 2015年 shanpengtao. All rights reserved.
//

#import "Utility.h"

#define IS_NOT_EMPTY(string) (string != nil && [string isKindOfClass:[NSString class]] && ![string isKindOfClass:[NSNull class]] && ![@"" isEqualToString:string] && ![@"NULL" isEqualToString:[string uppercaseString]] && ![@"null" isEqualToString:string] && ![@"(null)" isEqualToString:string])

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define HEX_COLOR(color) [UIColor colorWithString:color]