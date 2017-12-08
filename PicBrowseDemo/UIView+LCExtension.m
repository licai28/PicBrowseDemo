//
//  UIView+LCExtension.m
//
//  Created by MoneyLee on 2016/11/16.
//  Copyright © 2016年 MoneyLee. All rights reserved.
//

#import "UIView+LCExtension.h"

@implementation UIView (LCExtension)


- (CGSize)lc_size
{
    return self.frame.size;
}

- (void)setLc_size:(CGSize)lc_size
{
    CGRect frame = self.frame;
    frame.size = lc_size;
    self.frame = frame;
}

- (CGFloat)lc_width
{
    return self.frame.size.width;
}

- (CGFloat)lc_height
{
    return self.frame.size.height;
}

- (void)setLc_width:(CGFloat)lc_width
{
    CGRect frame = self.frame;
    frame.size.width = lc_width;
    self.frame = frame;
}

- (void)setLc_height:(CGFloat)lc_height
{
    CGRect frame = self.frame;
    frame.size.height = lc_height;
    self.frame = frame;
}

- (CGFloat)lc_x
{
    return self.frame.origin.x;
}

- (void)setLc_x:(CGFloat)lc_x
{
    CGRect frame = self.frame;
    frame.origin.x = lc_x;
    self.frame = frame;
}

- (CGFloat)lc_y
{
    return self.frame.origin.y;
}

- (void)setLc_y:(CGFloat)lc_y
{
    CGRect frame = self.frame;
    frame.origin.y = lc_y;
    self.frame = frame;
}

- (CGFloat)lc_centerX
{
    return self.center.x;
}

- (void)setLc_centerX:(CGFloat)lc_centerX
{
    CGPoint center = self.center;
    center.x = lc_centerX;
    self.center = center;
}

- (CGFloat)lc_centerY
{
    return self.center.y;
}

- (void)setLc_centerY:(CGFloat)lc_centerY
{
    CGPoint center = self.center;
    center.y = lc_centerY;
    self.center = center;
}

- (CGFloat)lc_right
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)lc_top
{
    return CGRectGetMinY(self.frame);
}


- (CGFloat)lc_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setLc_right:(CGFloat)lc_right
{
    self.lc_x = lc_right - self.lc_width;
}

- (void)setLc_bottom:(CGFloat)lc_bottom
{
    self.lc_y = lc_bottom - self.lc_height;
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (BOOL)intersectWithView:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}

@end
