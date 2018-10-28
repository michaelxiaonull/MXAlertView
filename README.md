
`MXAlertView` is an easy popView to use !

## Screenshots

选择按钮一个 | 选择按钮两个 | 选择按钮三个 | 自定义accessoryView
---|----|----|-----
<image src="https://user-images.githubusercontent.com/17949980/35078903-90963830-fc3f-11e7-8184-7438aaaa1657.gif" width="250">|<image src="https://user-images.githubusercontent.com/17949980/35079532-23b47e58-fc43-11e7-8a75-21eaeac65344.gif" width="250">|<image src="https://user-images.githubusercontent.com/17949980/35079615-a73f41b8-fc43-11e7-9640-56ca24e0dc6e.gif" width="250"> | <image src="https://user-images.githubusercontent.com/17949980/35079974-b3bebe1c-fc45-11e7-842a-22296ecfcc1b.gif" width="250">



## How To Use

### Base

``` Objective-C
- (IBAction)alertTypeOneClicked {
    
    [MXAlertView showWithTopTitle:@"提示" bottomTitles:@[@"关闭播放"] content:@"你当前在4G模式，确定要播放？" dataSource:nil completionHandler:nil];
}

- (IBAction)alertTypeTwoClicked {
    
    [MXAlertView showWithTopTitle:@"提示" bottomTitles:@[@"关闭播放", @"前去设置"] content:@"你当前在4G模式，确定要播放？" dataSource:nil completionHandler:nil];
}

- (IBAction)alertTypeThreeClicked {

    [MXAlertView showWithTopTitle:@"提示" bottomTitles:@[@"关闭播放", @"继续播放", @"前去设置"] content:@"你当前在4G模式，确定要播放？" dataSource:nil completionHandler:^(int index, UIButton *sender) {
        
        //selected index is index in the `bottomTitles`
        if (index == 0) {
            //关闭播放
        } else if (index == 1) {
            //继续播放
        } else {
            //前去设置
        }
    }];
}

```

### Custom
set `dataSource` and implement method `accessoryViewForContentInMXAlertView` declared in `MXAlertViewDataSource` protocol
 
``` Objective-C
- (IBAction)alertTypeFourClicked {
    
    [MXAlertView showWithTopTitle:@"提示" bottomTitles:@[@"关闭播放", @"前去设置"] content:@"你当前在4G模式，确定要播放？" dataSource:self completionHandler:^(int index, UIButton *sender) {
        
        //selected index is the same index as title in the `bottomTitles`
        if (index == 0) {
            //关闭播放
        } else if (index == 1) {
            //继续播放
        } else {
            //前去设置
        }
    }];
}

- (UIView *)accessoryViewForContentInMXAlertView:(MXAlertView *)alertView {
    
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 4 * 15, 20)];
    
    UIView *timerImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    timerImageView.layer.contents = (__bridge id)[[UIImage imageNamed:@"时钟.png"] CGImage];
    [accessoryView addSubview:timerImageView];
    
    CGRect timerImageViewFrame = timerImageView.frame;
    UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timerImageViewFrame) + 2, timerImageViewFrame.origin.y, 50, CGRectGetHeight(timerImageViewFrame))];
    timerLabel.font = [UIFont systemFontOfSize:15];
    timerLabel.textColor = [UIColor colorWithRed:49/255.0 green:194/255.0 blue:124/255.0 alpha:1.0];
    timerLabel.text = @"2:00";
    [accessoryView addSubview:timerLabel];
    
    return accessoryView;
}


```

<br/>

## 中文描述

`MXAlertView` 是一个使用简单的弹出视图!

## 效果截图

选择按钮一个 | 选择按钮两个 | 选择按钮三个 | 自定义accessoryView
---|----|----|-----
![选择按钮一个.gif](http://upload-images.jianshu.io/upload_images/2546918-9d0c674296e67ec9.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/250) |![选择按钮两个.gif](http://upload-images.jianshu.io/upload_images/2546918-934cd9ace59b0af4.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/250)|![选择按钮三个.gif](http://upload-images.jianshu.io/upload_images/2546918-83d05053f3373299.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/250)| ![自定义accessoryView.gif](http://upload-images.jianshu.io/upload_images/2546918-824f4ca7c7ddb37f.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/250)



## 如何使用

### 基本用法

``` Objective-C
- (IBAction)alertTypeOneClicked {
    
    [MXAlertView showWithTopTitle:@"提示" bottomTitles:@[@"关闭播放"] content:@"你当前在4G模式，确定要播放？" dataSource:nil completionHandler:nil];
}

- (IBAction)alertTypeTwoClicked {
    
    [MXAlertView showWithTopTitle:@"提示" bottomTitles:@[@"关闭播放", @"前去设置"] content:@"你当前在4G模式，确定要播放？" dataSource:nil completionHandler:nil];
}

- (IBAction)alertTypeThreeClicked {

    [MXAlertView showWithTopTitle:@"提示" bottomTitles:@[@"关闭播放", @"继续播放", @"前去设置"] content:@"你当前在4G模式，确定要播放？" dataSource:nil completionHandler:^(int index, UIButton *sender) {
        
        //selected index is index in the `bottomTitles`
        if (index == 0) {
            //关闭播放
        } else if (index == 1) {
            //继续播放
        } else {
            //前去设置
        }
    }];
}

```

### 自定义

设置 `dataSource` 之后在代理中实现`MXAlertViewDataSource` 中的`accessoryViewForContentInMXAlertView`
 
``` Objective-C
- (IBAction)alertTypeFourClicked {
    
    [MXAlertView showWithTopTitle:@"提示" bottomTitles:@[@"关闭播放", @"前去设置"] content:@"你当前在4G模式，确定要播放？" dataSource:self completionHandler:^(int index, UIButton *sender) {
        
        //selected index is the same index as title in the `bottomTitles`
        if (index == 0) {
            //关闭播放
        } else if (index == 1) {
            //继续播放
        } else {
            //前去设置
        }
    }];
}

- (UIView *)accessoryViewForContentInMXAlertView:(MXAlertView *)alertView {
    
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 4 * 15, 20)];
    
    UIView *timerImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    timerImageView.layer.contents = (__bridge id)[[UIImage imageNamed:@"时钟.png"] CGImage];
    [accessoryView addSubview:timerImageView];
    
    CGRect timerImageViewFrame = timerImageView.frame;
    UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timerImageViewFrame) + 2, timerImageViewFrame.origin.y, 50, CGRectGetHeight(timerImageViewFrame))];
    timerLabel.font = [UIFont systemFontOfSize:15];
    timerLabel.textColor = [UIColor colorWithRed:49/255.0 green:194/255.0 blue:124/255.0 alpha:1.0];
    timerLabel.text = @"2:00";
    [accessoryView addSubview:timerLabel];
    
    return accessoryView;
}


```
