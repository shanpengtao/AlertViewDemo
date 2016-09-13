//
//  JobAlertView.h
//  AlertViewDemo
//
//  Created by shanpengtao on 16/8/31.
//  Copyright © 2016年 shanpengtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlertBackgroundView.h"

/* 开启毛玻璃效果 */
#define OPEN_WOOLGLASS

/* 开启动画 */
#define OPEN_AIMATION

/* 开启手势 */
#define OPEN_GESTURE

/* 开启旋转 */
#define OPEN_TOTATE

typedef void(^JobAlertBlock)(NSInteger buttonIndex);

#ifdef OPEN_WOOLGLASS
@interface JobAlertView : AlertBackgroundView
#else
@interface JobAlertView : UIView
#endif

/**
 *  控件初始化
 *  @param title                顶部标题
 *  @param message              提示内容
 *  @param cancelButtonTitle    第一个按钮文案
 *  @param otherButtonTitle     其他按钮文案
 *  @param aCallback            回调
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     callback:(JobAlertBlock)aCallback;

/**
 *  @abstract 普通展示
 *  @discussion 弹出带动画的自定义alertView
 */
- (void)show;

/**
 *  隐藏提示框
 */
- (void)dismiss;

@end


