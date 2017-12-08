//
//  ZoomImageView.m
//  PicBrowseDemo
//
//  Created by MoneyLee on 2017/12/4.
//  Copyright © 2017年 MoneyLee. All rights reserved.
//

#import "ZoomImageView.h"

@interface ZoomImageView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZoomImageView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.backgroundColor = [UIColor blackColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor grayColor];
        //双击放大，单击退出
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleDoubleTap:)];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleSingleTap:)];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPassAction:)];
        
        [singleTap requireGestureRecognizerToFail : doubleTap];
        [doubleTap setDelaysTouchesBegan : YES];
        [singleTap setDelaysTouchesBegan : YES];
        [doubleTap setNumberOfTapsRequired : 2];
        [singleTap setNumberOfTapsRequired : 1];
        [self addGestureRecognizer : doubleTap];
        [self addGestureRecognizer : singleTap];
        [self addGestureRecognizer : longPress];

    }
    return self;
}

#pragma mark - Properties
- (void) setImageURL:(NSString *)imageURL
{
    if (_imageURL) { //如果已经加载过，不再加载
        return;
    }
    _imageURL = imageURL;
    UIImage * image = nil;
    if ([_imageURL isKindOfClass:[NSString class]]) {
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    }else{
        image = (UIImage *)_imageURL;
    }
    
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat fullWidth = self.frame.size.width;
    CGFloat fullHeight = self.frame.size.height;
    
    //适应屏幕大小
    CGFloat rWidth = fullWidth / imageWidth;
    CGFloat rHeight = fullHeight / imageHeight;
    CGFloat rate = MIN(rWidth, rHeight);
    CGFloat imageViewWidth = imageWidth * rate;
    CGFloat imageViewHeight = imageHeight * rate;
    
    //居中
    CGFloat imageViewX = (fullWidth - imageViewWidth) / 2;
    CGFloat imageViewY = (fullHeight - imageViewHeight) / 2;
    
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    self.imageView.image = image;
    
    NSLog(@"x: %0.0f, y:%0.0f, width: %0.0f, height: %0.0f", imageViewX, imageViewY,imageViewWidth, imageViewHeight);
    
    CGFloat maxScale = 1 / rate;
    self.maximumZoomScale = maxScale > 1 ? maxScale : 1; //防止图片本身比屏幕小
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


#pragma mark - Public Methods
- (void) zoomBack
{
    if (self.zoomScale != self.minimumZoomScale) {
        self.zoomScale = self.minimumZoomScale;
    }
}

#pragma mark -  Private Methods

- (void) handleDoubleTap: (UITapGestureRecognizer *)sender
{
    if (self.zoomScale > self.minimumZoomScale) {
        self.zoomScale = self.minimumZoomScale;
    } else {
        CGFloat zoomScale = self.maximumZoomScale;
        CGPoint touchPoint = [sender locationInView: nil];
        NSLog(@"touchPoint x: %0.0f, y: %0.0f", touchPoint.x, touchPoint.y);
        CGFloat centerX = self.frame.size.width / 2;
        CGFloat centerY = self.frame.size.height / 2;
        NSLog(@"centerX: %0.0f, centerY: %0.0f", centerX,centerY);
        CGPoint contentOffeset = CGPointMake((touchPoint.x - centerX) * zoomScale , (touchPoint.y - centerY) * zoomScale);
        [self setContentOffset:contentOffeset animated:YES];
        
        [self setZoomScale:self.maximumZoomScale animated:NO];
    }
}

- (void)longPassAction:(UILongPressGestureRecognizer *)longPress{
    //长按手势
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        if (self.sigleImageDelegate && [self.sigleImageDelegate respondsToSelector:@selector(saveImage)]) {
            [self.sigleImageDelegate saveImage];
        }
        
    }
}


- (void) handleSingleTap: (UITapGestureRecognizer *)sender
{
    if (self.zoomScale > self.minimumZoomScale) {
        return;
    }
    if (self.sigleImageDelegate && [self.sigleImageDelegate respondsToSelector:@selector(browseEnd)]) {
        [self.sigleImageDelegate browseEnd];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
