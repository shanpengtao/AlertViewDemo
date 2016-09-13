//
//  JobAlertManager.h
//  AlertViewDemo
//
//  Created by shanpengtao on 16/8/31.
//  Copyright © 2016年 shanpengtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JobAlertView.h"



@interface JobAlertManager : NSObject

/**
 *  关闭当前alertview
 */
+ (void)closeAlert;

/**
 *  显示普通提示框
 *
 *  @param title        提示框标题
 *  @param message      提示框信息
 *  @cancelButtonTitle  取消按钮文字
 *  @otherButtonTitles  其他按钮文字数组
 *  @param aCallback    按钮被按下后的回调
 */
+ (void)showAlertViewWithTitle:(NSString *)yesText
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                      callback:(JobAlertBlock)aCallback;


@end
