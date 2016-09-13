//
//  JobAlertView.m
//  AlertViewDemo
//
//  Created by shanpengtao on 16/8/31.
//  Copyright © 2016年 shanpengtao. All rights reserved.
//

#import "JobAlertView.h"
#import "Defines.h"

@interface JobAlertView ()

/* 旋转角度 */
#ifdef OPEN_TOTATE
#define K_TOTATE_ANGLE 45
#else
#define K_TOTATE_ANGLE 0
#endif

/* 开启移动透明效果 */
#ifndef OPEN_AIMATION
#define OPEN_MOVE_TRANS
#endif

/* 透明度 */
#ifdef OPEN_WOOLGLASS
#define K_ALPHA 0
#else
#define K_ALPHA 0.65
#endif

/* 视图圆角 */
#define K_ALERT_RADIUS 8

/* 视图底部的Y坐标 */
#define GetBottom(view) (view.frame.origin.y + view.frame.size.height)

/* 提示框标题的字体 */
#define K_TITLE_FONT [UIFont boldSystemFontOfSize:15]

/* 提示框内容的字体 */
#define K_CONTENT_FONT [UIFont systemFontOfSize:14]

/* 提示框标题的字体颜色 */
#define K_TITLE_FONTCOLOR HEX_COLOR(@"#333333")

/* 提示框内容的字体颜色 */
#define K_CONTENT_FONTCOLOR HEX_COLOR(@"#333333")

/* 提示框主体文字距左右的间距 */
#define K_OFFSET_X 28

/* 提示框主体控件与控件的间距 */
#define K_OFFSET_PADDING 25

/* 提示框标题的行间距 */
#define K_TITLTE_OFFSET_SPACE 8

/* 提示框内容的行间距 */
#define K_CONTENT_OFFSET_SPACE 7

/* 提示框最大高度 */
#define K_ALERT_MAX_HEIGHT (SCREENHEIGHT - 40)

/* 提示框的最大宽度 */
#define K_ALERT_MAX_WIDTH 280

/* 提示框的最小高度 */
#define K_ALERT_MIN_HEIGHT 130

/* 按钮高度 */
#define K_BUTTON_HEIGHT 45

/* 按钮tag */
#define K_BUTTON_TAG 99999

/* 提示框 */
@property (nonatomic, strong) UIView *alertView;

/* 内容 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 内容 */
@property (nonatomic, strong) UILabel *contentLabel;

/* 传入的标题 */
@property (nonatomic, strong) NSString *title;

/* 传入的消息 */
@property (nonatomic, strong) NSString *message;

/* 按钮的数组--默认最后一个为取消按钮 */
@property (nonatomic, strong) NSMutableArray *buttonTitles;

/* 回调的block */
@property (nonatomic, copy) JobAlertBlock alertCallback;

/* 提示框高度 */
@property (nonatomic, assign) CGFloat alertHeight;

/* 提示框frame */
@property (nonatomic, assign) CGRect alertFrame;

/* 记录旋转时的角度 1 or -1 */
@property (nonatomic, assign) CGFloat rorateDirection;

/* 记录点击的按钮index */
@property (nonatomic, assign) NSInteger selectedIndx;

@end

@implementation JobAlertView

- (void)dealloc
{
    
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     callback:(JobAlertBlock)aCallback
{
    self = [super init];
    
    if (self) {
        
        if (IS_NOT_EMPTY(message)) {
            _message = message;
            
            if (IS_NOT_EMPTY(title)) {
                _title = title;
            }
        }
        else {
            _message = title;
        }
        
        if (otherButtonTitles.count) {
            [self.buttonTitles addObjectsFromArray:otherButtonTitles];
        }
        
        if (cancelButtonTitle) {
            [self.buttonTitles addObject:cancelButtonTitle];
        }
        
        if (self.buttonTitles.count == 0) {
            // 为空时加入一个确定按钮，防止异常
            [self.buttonTitles addObject:@"确定"];
        }
        
        _alertCallback = aCallback;
        
        [self addSubviews];
    }
    
    return self;
}

#pragma mark - Init UI

- (void)addSubviews
{
    [self addBackground];
    
    [self addAlertView];
    
    [self addLabel];
    
    [self addButton];
}

- (void)addBackground
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:K_ALPHA];
    self.alpha = 0;
}

- (void)addAlertView
{
#ifdef OPEN_MOVE_TRANS
    [self addSubview:self.alertView];
#else
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.alertView];
#endif
}

- (void)addLabel
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    CGFloat titleWidth = K_ALERT_MAX_WIDTH - 2 * K_OFFSET_X;
    CGFloat titleHeight = self.buttonTitles.count <= 2 ? K_ALERT_MAX_HEIGHT - K_BUTTON_HEIGHT : K_ALERT_MAX_HEIGHT - self.buttonTitles.count * K_BUTTON_HEIGHT;
    
    if (IS_NOT_EMPTY(_title)) {
        // 计算单行高度
        int lineHeight = (int)[@"单行" boundingRectWithSize:CGSizeMake(titleWidth, titleHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height;
        
        int height = (int)[_title boundingRectWithSize:CGSizeMake(titleWidth, titleHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height;
        
        if (lineHeight == height) {
            // 单行时lineSpace = 0;
            paragraphStyle.lineSpacing = 0;
        }
        else {
            paragraphStyle.lineSpacing = K_TITLTE_OFFSET_SPACE;
        }
        
        NSDictionary *attributes = @{NSFontAttributeName:K_TITLE_FONT, NSForegroundColorAttributeName : K_TITLE_FONTCOLOR, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_title attributes:attributes];
        CGFloat labelHeight = [attStr.string boundingRectWithSize:CGSizeMake(titleWidth, titleHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        
        self.titleLabel.attributedText = attStr;
        
        self.titleLabel.frame = CGRectMake(K_OFFSET_X, K_OFFSET_PADDING, titleWidth, labelHeight);
        
        [self.alertView addSubview:self.titleLabel];
        
        _alertHeight = GetBottom(self.titleLabel) + K_OFFSET_PADDING;
    }
    
    CGFloat messageHeight = self.buttonTitles.count <= 2 ? titleHeight - _alertHeight: titleHeight - _alertHeight;
    
    if (IS_NOT_EMPTY(_message)) {
        if (_alertHeight <= 0) {
            _alertHeight = K_OFFSET_PADDING + 5;
        }
        // 计算单行高度
        int lineHeight = (int)[@"单行" boundingRectWithSize:CGSizeMake(titleWidth, messageHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height;
        
        int height = (int)[_message boundingRectWithSize:CGSizeMake(titleWidth, messageHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height;
        
        if (lineHeight == height) {
            // 单行时lineSpace = 0;
            paragraphStyle.lineSpacing = 0;
        }
        else {
            paragraphStyle.lineSpacing = K_CONTENT_OFFSET_SPACE;
        }
        
        NSDictionary *attributes = @{NSFontAttributeName:K_CONTENT_FONT, NSForegroundColorAttributeName : K_CONTENT_FONTCOLOR, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_message attributes:attributes];
        CGFloat labelHeight = [attStr.string boundingRectWithSize:CGSizeMake(titleWidth, messageHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        
        self.contentLabel.attributedText = attStr;
        
        self.contentLabel.frame = CGRectMake(K_OFFSET_X, _alertHeight - 5, titleWidth, labelHeight);
        
        [self.alertView addSubview:self.contentLabel];
        
        _alertHeight = GetBottom(self.contentLabel) + K_OFFSET_PADDING;
    }
}

- (void)addButton
{
    switch (self.buttonTitles.count) {
        case 1:
            [self addOneButton];
            break;
        case 2:
            [self addTwoButton];
            break;
        default:
            [self addMoreButton];
            break;
    }
    
    _alertFrame = self.alertView.frame = CGRectMake((SCREENWIDTH - K_ALERT_MAX_WIDTH) / 2, (SCREENHEIGHT - _alertHeight) / 2, K_ALERT_MAX_WIDTH, _alertHeight);
}

- (void)addOneButton
{
    UIButton *button = [self creatButton];
    button.frame = CGRectMake(0, _alertHeight, K_ALERT_MAX_WIDTH, K_BUTTON_HEIGHT);
    button.tag = K_BUTTON_TAG;
    [button setTitle:[self.buttonTitles objectAtIndex:0] forState:UIControlStateNormal];
    [button setTitleColor:HEX_COLOR(@"#ff704f") forState:UIControlStateNormal];
    [_alertView addSubview:button];
    
    _alertHeight = _alertHeight + K_BUTTON_HEIGHT;
}

- (void)addTwoButton
{
    UIButton *button = [self creatButton];
    button.frame = CGRectMake(0, _alertHeight, K_ALERT_MAX_WIDTH / 2, K_BUTTON_HEIGHT);
    button.tag = K_BUTTON_TAG;
    [button setTitle:[self.buttonTitles objectAtIndex:1] forState:UIControlStateNormal];
    [button setTitleColor:HEX_COLOR(@"#666666") forState:UIControlStateNormal];
    [_alertView addSubview:button];
    
    UIButton *button2 = [self creatButton];
    button2.frame = CGRectMake(K_ALERT_MAX_WIDTH / 2, _alertHeight, K_ALERT_MAX_WIDTH / 2, K_BUTTON_HEIGHT);
    button2.tag = K_BUTTON_TAG + 1;
    [button2 setTitle:[self.buttonTitles objectAtIndex:0] forState:UIControlStateNormal];
    [button2 setTitleColor:HEX_COLOR(@"#ff704f") forState:UIControlStateNormal];
    [_alertView addSubview:button2];
    
    _alertHeight = _alertHeight + K_BUTTON_HEIGHT;
}

- (void)addMoreButton
{
    [self.buttonTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [self creatButton];
        button.frame = CGRectMake(0, _alertHeight + idx * K_BUTTON_HEIGHT, K_ALERT_MAX_WIDTH, K_BUTTON_HEIGHT);
        button.tag = K_BUTTON_TAG + idx + 1;
        [button setTitleColor:HEX_COLOR(@"#ff704f") forState:UIControlStateNormal];
        if (idx == self.buttonTitles.count - 1) {
            button.tag = K_BUTTON_TAG;
            [button setTitleColor:HEX_COLOR(@"#666666") forState:UIControlStateNormal];
        }
        [button setTitle:[self.buttonTitles objectAtIndex:idx] forState:UIControlStateNormal];
        [_alertView addSubview:button];
    }];
    
    _alertHeight = _alertHeight + self.buttonTitles.count * K_BUTTON_HEIGHT;
}

#pragma mark - Factory Method

- (UIButton *)creatButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.shadowColor = [HEX_COLOR(@"#999999") CGColor];
    button.layer.shadowRadius = 0.5;
    button.layer.shadowOpacity = 1;
    button.layer.shadowOffset = CGSizeZero;
    button.layer.masksToBounds = NO;
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setBackgroundImage:[UIImage imageFromColor:HEX_COLOR(@"#f6f6f6")]
                      forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor]]
                      forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - GET

- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = K_ALERT_RADIUS;
        _alertView.layer.masksToBounds = YES;
        
#ifdef OPEN_GESTURE // 开启手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        [_alertView addGestureRecognizer:panGesture];
#endif
    }
    return _alertView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _contentLabel;
}

- (NSMutableArray *)buttonTitles
{
    if (!_buttonTitles) {
        _buttonTitles = [[NSMutableArray alloc] init];
    }
    return _buttonTitles;
}

#pragma mark - Button Action

- (void)buttonAction:(UIButton *)sender
{
    _rorateDirection = 1;
    
    _selectedIndx = sender.tag - K_BUTTON_TAG;
    
    [self dismiss];
}

#pragma mark - Other Action

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];//先释放键盘
    
#ifdef OPEN_AIMATION
    self.alpha = 1;
    
    CGFloat y = -(SCREENHEIGHT + CGRectGetHeight(_alertView.frame)/2);
    _alertView.center = CGPointMake(_alertView.center.x, y);
    _alertView.transform = CGAffineTransformMakeRotation(K_TOTATE_ANGLE);
#endif
    
    
    // animation
    [UIView animateWithDuration:0.6
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.9
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
#ifdef OPEN_AIMATION
                         _alertView.transform = CGAffineTransformMakeRotation(0);
                         _alertView.center = CGPointMake(CGRectGetMidX(self.bounds),
                                                         CGRectGetMidY(self.bounds));
                         
#endif
                         
                         self.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                     }];
    
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.6f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
#ifdef OPEN_AIMATION
                         
                         CGRect rect = _alertView.frame;
                         rect.size.width = K_ALERT_MAX_WIDTH;
                         rect.origin.y = SCREENHEIGHT + self.alertView.bounds.size.height;
                         _alertView.frame = rect;
                         _alertView.transform = CGAffineTransformMakeRotation(K_TOTATE_ANGLE * _rorateDirection);
#endif
                         
                         self.alpha = 0;
                         
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         
                         [_alertView removeFromSuperview];
                         
                         [self removeFromSuperview];
                         
                         if (_alertCallback) {
                             _alertCallback(_selectedIndx);
                         }
                     }];
}

#pragma mark - gesture recognizer

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    
    UIView *view = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint position =  [recognizer locationInView:view];
        _rorateDirection = position.x > CGRectGetMidX(view.bounds) ? 1 : -1;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged) {
        // rotate
        float ratio = (_alertView.frame.origin.y - _alertFrame.origin.y) / SCREENHEIGHT;
        
        // change background alpha when slide down
        if (ratio > 0) {
            self.alpha = 1 - ratio * 1;
        }
        
        CGFloat radian = K_TOTATE_ANGLE * (M_PI / 180) * ratio * _rorateDirection;
        view.transform = CGAffineTransformMakeRotation(radian);
        
        CGPoint location = [recognizer locationInView:view.superview];
        location.x = SCREENWIDTH / 2;
        view.center = location;
    }
    else {
        [self panEnd];
    }
}

- (void)panEnd {
    if (fabs(self.alertView.center.y - self.bounds.size.height) < (self.bounds.size.height / 4)) {
        [self dismiss];
    } else {
        [self resetAlertView];
    }
}

- (void)resetAlertView {
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _alertView.transform = CGAffineTransformMakeRotation(0);
                         
                         self.alertView.frame = _alertFrame;
                         
                         self.alpha = 1;
                         
                         [self layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                     }];
}

@end



