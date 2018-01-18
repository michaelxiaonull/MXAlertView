//
//  MXAlertView.m
//  0619 - MXAlertView
//
//  Created by Michael on 2017/6/19.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "MXAlertView.h"

#define MX_ALERT_VIEW_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define MX_ALERT_VIEW_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MX_ALERT_VIEW_WINDOW_CENTER    [UIApplication sharedApplication].keyWindow.center
#define POPINPUT_VIEW_W   self.frame.size.width
#define BOTTOM_LABEL_H    ((_bottomTitle.length) ? 20 : 0)

static const CGFloat  TOP_TITLE_LABEL_H = 40;
static const CGFloat  MARGIN_LEFT = 15;
//static const CGFloat  BOTTOM_PADDING = 10;
//static const CGFloat  CONFIRM_BUTTON_H = 35;

#define kGreenColor      [UIColor colorWithRed:49/255.0 green:194/255.0 blue:124/255.0 alpha:1.0]
#define kBlueColor       [UIColor colorWithRed:50.0/255.0 green:162.0/255.0 blue:248.0/255.0 alpha:1.0]
#define kGrayColor       [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1.0]
#define kSeparatorLineColor [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]
static BOOL isCliked = NO;

@interface MXAlertView() {
    
    NSString *_bottomTitle;
}

@property(nonatomic, copy) void(^bottomButtonDidClickBlock)(int index, UIButton *);

@end

@implementation MXAlertView

- (instancetype)initWithTopTitle:(NSString *)topTitle bottomTitles:(NSArray<NSString*> *)bottomTitles content:(NSString *)content dataSource:(id<MXAlertViewDataSource>)dataSource {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //高度未知，需要根据传来的数据动态生成,需要给个Width因为后面只改了高度，没设置width
    self.bounds = CGRectMake(0, 0, MX_ALERT_VIEW_SCREEN_WIDTH - 4 * MARGIN_LEFT, 0);
    //设置背白色背景
    self.backgroundColor = [UIColor whiteColor];
    //设置圆角大小
    self.layer.cornerRadius = 7.0f;
    self.clipsToBounds = YES;
    self.center = MX_ALERT_VIEW_WINDOW_CENTER;
    
    //在window上加载遮罩视图
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *maskView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _maskView = maskView;
    
    //在遮罩视图上加入单击手势用来响应hide方法
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewSingleTapInvoked:)];
    [maskView addGestureRecognizer:singleTap];
    [keyWindow addSubview:maskView];
    
    //在window上加载self
    [keyWindow addSubview:self];
    
    //加载自定义视图如顶部标题label和底部label还有确认按钮
    [self addCustomViewWithTopTitle:topTitle bottomTitles:bottomTitles content:content dataSource:dataSource];
    
    return self;
}

#pragma mark - add UI
- (void)addCustomViewWithTopTitle:(NSString *)topTitle bottomTitles:(NSArray<NSString*> *)bottomTitles content:(NSString *)content dataSource:(id<MXAlertViewDataSource>)dataSource {
    
    //加载顶部标题Label，让其永远在顶部
    UILabel *topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, POPINPUT_VIEW_W, TOP_TITLE_LABEL_H)];
    topTitleLabel.font = [UIFont systemFontOfSize:16];
    topTitleLabel.textColor = [UIColor blackColor];
    topTitleLabel.textAlignment = NSTextAlignmentCenter;
    [topTitleLabel setBackgroundColor:[UIColor whiteColor]];
    topTitleLabel.text = [NSString stringWithFormat:@"%@", topTitle];//加两个空格看起来不让他左对齐即可
    [self addSubview:topTitleLabel];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topTitleLabel.frame), POPINPUT_VIEW_W, 0.5)];
    separatorLine.backgroundColor = kSeparatorLineColor;
    [self addSubview:separatorLine];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(separatorLine.frame), self.frame.size.width - 2 * 5, TOP_TITLE_LABEL_H * 1.5)];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 0;
    [contentLabel setBackgroundColor:[UIColor whiteColor]];
    contentLabel.text = content;
    [self addSubview:contentLabel];
    
    UIView *accessoryView = nil;
    if ([dataSource respondsToSelector:@selector(accessoryViewForContentInMXAlertView:)]) {
        
        accessoryView = [dataSource accessoryViewForContentInMXAlertView:self];
        accessoryView.frame = (CGRect){CGPointMake(CGRectGetWidth(self.frame)/2.0 - 25, CGRectGetMaxY(contentLabel.frame) - 5), accessoryView.bounds.size};
        [self addSubview:accessoryView];
    }
    
    CGFloat separatorLineY = !accessoryView ? CGRectGetMaxY(contentLabel.frame) : CGRectGetMaxY(accessoryView.frame) + 5;
    separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, separatorLineY, POPINPUT_VIEW_W, 0.5)];
    separatorLine.backgroundColor = kSeparatorLineColor;
    [self addSubview:separatorLine];
    
    CGFloat buttonY = CGRectGetMaxY(separatorLine.frame), buttonW = POPINPUT_VIEW_W/bottomTitles.count, buttonH = 40;
    int index = 0;
    UIButton *bottomButton = nil;
    for (NSString *bottomTitle in bottomTitles) {
        
        bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomButton setBackgroundImage:[self getImageWithColor:[UIColor colorWithWhite:0.95 alpha:1.0]] forState:UIControlStateHighlighted];
        bottomButton.frame = CGRectMake(buttonW * index, buttonY, buttonW, buttonH);
        bottomButton.clipsToBounds = YES;
        bottomButton.tag = index;
        [bottomButton setTitle:bottomTitle forState:UIControlStateNormal];
        bottomButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [bottomButton addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (index == 0 && bottomTitles.count > 1) {
            [bottomButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        } else {
            [bottomButton setTitleColor:kGreenColor forState:UIControlStateNormal];
        }
        [self addSubview:bottomButton];
        
        index++;
    }
    self.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetMaxY(bottomButton.frame));
    self.center = self.superview.center;
}

#pragma mark - public methods
/**
 * 显示弹出视图
 */
+ (instancetype)showWithTopTitle:(NSString *)topTitle bottomTitles:(NSArray<NSString*> *)bottomTitles content:(NSString *)content dataSource:(id<MXAlertViewDataSource>)dataSource completionHandler:(void(^)(int index, UIButton *sender))completionHandler {
    
    if (isCliked) {
        return nil;
    }
    MXAlertView *popInputView = [[MXAlertView alloc] initWithTopTitle:topTitle bottomTitles:bottomTitles content:content dataSource:dataSource];
    popInputView.dataSource = dataSource;
    popInputView.bottomButtonDidClickBlock = completionHandler;
    
    [popInputView addScaleAnimationWithDuration:0.35f];
    [UIView animateWithDuration:0.35f delay:0.0f usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //在动画过程中禁止遮罩视图响应用户手势
        popInputView.maskView.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        
        //在动画结束后允许遮罩视图响应用户手势
        popInputView.maskView.userInteractionEnabled = YES;
    }];
    isCliked = YES;
    
    return popInputView;
}

///隐藏弹出视图
- (void)hide {
    
    [self removeScaleAnimationWithDuration:0.20f];
    [UIView animateWithDuration:0.35f delay:0.0f usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //在动画过程中禁止遮罩视图响应用户手势
        _maskView.userInteractionEnabled = NO;
        _maskView.alpha = 0.01;
    } completion:^(BOOL finished) {
        
        [_maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
    isCliked = NO;
}

#pragma mark - button actions
- (void)bottomButtonClicked:(UIButton *)sender {
    
    [self hide];
    !_bottomButtonDidClickBlock ?:_bottomButtonDidClickBlock((int)sender.tag, sender);
}

#pragma mark - gesture actions
- (void)maskViewSingleTapInvoked:(UITapGestureRecognizer *)recognizer {
    
    [self hide];
    !_bottomButtonDidClickBlock ?:_bottomButtonDidClickBlock(-100, nil);
}

#pragma mark - scale animation
- (void)addScaleAnimationWithDuration:(NSTimeInterval)duration {
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@0.01, @1.13, @0.9, @1.0];
    scaleAnimation.duration = duration;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scaleAnimation forKey:nil];
}

- (void)removeScaleAnimationWithDuration:(NSTimeInterval)duration {
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@1.0, @0.01];
    scaleAnimation.duration = duration;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scaleAnimation forKey:nil];
}

#pragma mark - Utils
- (UIImage *)getImageWithColor:(UIColor *)color {
    
    CGSize size = CGSizeMake(1, 1);
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
