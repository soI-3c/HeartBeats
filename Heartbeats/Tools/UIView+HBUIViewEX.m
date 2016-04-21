//
//  UIView+HBUIViewEX.m
//  网易彩票
//
//  Created by apple on 15/8/1.
//  Copyright (c) 2015年 HeartBeats. All rights reserved.
//

#import "UIView+HBUIViewEX.h"

@implementation UIView (HBUIViewEX)
-(CGFloat)x{
    return self.frame.origin.x;
}


-(void)setX:(CGFloat)x{
    CGRect oldFrame = self.frame;
    oldFrame.origin.x = x;
    self.frame = oldFrame;
    
}

-(CGFloat)y{
     return self.frame.origin.y;
}

-(void)setY:(CGFloat)y{
    CGRect oldFrame = self.frame;
    oldFrame.origin.y = y;
    self.frame = oldFrame;

}

-(CGFloat)width{
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width{
    CGRect oldFrame = self.frame;
    oldFrame.size.width = width;
    self.frame = oldFrame;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height{
    CGRect oldFrame = self.frame;
    oldFrame.size.height = height;
    self.frame = oldFrame;

}
@end
