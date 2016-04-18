//
//  UIView+HBUIViewEX.h
//  网易彩票
//
//  Created by apple on 15/8/1.
//  Copyright (c) 2015年 HeartBeats. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
    UIView的分类，为了方便快速设置view的x,y,w,h
 */
@interface UIView (HBUIViewEX)

@property(nonatomic,assign) CGFloat x;
@property(nonatomic,assign) CGFloat y;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;

@end
