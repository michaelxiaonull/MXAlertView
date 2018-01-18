//
//  MXAlertView.h
//  0619 - MXAlertView
//
//  Created by Michael on 2017/6/19.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXAlertView;
@protocol MXAlertViewDataSource <NSObject>

- (UIView *)accessoryViewForContentInMXAlertView:(MXAlertView *)alertView;

@end

@interface MXAlertView : UIView

@property(weak, nonatomic) UIView *maskView;
@property(nonatomic, weak) id<MXAlertViewDataSource> dataSource;
/**
 * 显示弹出视图
 */
+ (instancetype)showWithTopTitle:(NSString *)topTitle bottomTitles:(NSArray<NSString*> *)bottomTitles content:(NSString *)content dataSource:(id<MXAlertViewDataSource>)dataSource completionHandler:(void(^)(int index, UIButton *sender))completionHandler;

/**
 * 隐藏弹出视图
 */
- (void)hide;

@end
