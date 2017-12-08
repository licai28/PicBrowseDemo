//
//  ZoomImageView.h
//  PicBrowseDemo
//
//  Created by MoneyLee on 2017/12/4.
//  Copyright © 2017年 MoneyLee. All rights reserved.
//

#import <UIKit/UIKit.h>
//浏览
@protocol ZoomImageViewDelegate<NSObject>
- (void) browseEnd;
- (void) saveImage;
@end
@interface ZoomImageView : UIScrollView
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) id<ZoomImageViewDelegate> sigleImageDelegate;

- (void) zoomBack;

@end
