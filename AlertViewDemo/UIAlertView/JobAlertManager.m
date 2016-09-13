//
//  JobAlertManager.m
//  AlertViewDemo
//
//  Created by shanpengtao on 16/8/31.
//  Copyright © 2016年 shanpengtao. All rights reserved.
//

#import "JobAlertManager.h"

@interface JobAlertManager ()

@end

@implementation JobAlertManager

static JobAlertView *_alertView;

+ (void)closeAlert
{
    if (_alertView)
    {
        [_alertView removeFromSuperview];
        _alertView = nil;
    }
}

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                      callback:(JobAlertBlock)aCallback
{
    if (_alertView)
    {
        [_alertView removeFromSuperview];
        _alertView = nil;
    }
    
    _alertView = [[JobAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles callback:aCallback];
    [_alertView show];
}

@end
