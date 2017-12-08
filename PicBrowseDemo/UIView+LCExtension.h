//
//  UIView+LCExtension.h
//
//  Created by MoneyLee on 2016/11/16.
//  Copyright © 2016年 MoneyLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LCExtension)


@property (nonatomic, assign) CGSize lc_size;
@property (nonatomic, assign) CGFloat lc_width;
@property (nonatomic, assign) CGFloat lc_height;
@property (nonatomic, assign) CGFloat lc_x;
@property (nonatomic, assign) CGFloat lc_y;
@property (nonatomic, assign) CGFloat lc_centerX;
@property (nonatomic, assign) CGFloat lc_centerY;

@property (nonatomic, assign) CGFloat lc_right;
@property (nonatomic, assign) CGFloat lc_bottom;
@property (nonatomic, assign) CGFloat lc_top;

+ (instancetype)viewFromXib;

- (BOOL)intersectWithView:(UIView *)view;



@end
