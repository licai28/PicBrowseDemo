//
//  ShowImagesViewController.m
//  PicBrowseDemo
//
//  Created by MoneyLee on 2017/12/3.
//  Copyright © 2017年 MoneyLee. All rights reserved.
//

#import "ShowImagesViewController.h"
#import "UIView+LCExtension.h"
#import "ZoomImageView.h"
#import <Masonry.h>
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
/*** 颜色 ***/
#define GRColorA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define GRColor(r, g, b) GRColorA((r), (g), (b), 255)
#define GRRandomColor GRColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define GRGrayColor(v) GRColor((v), (v), (v))
#define GRCommonBgColor GRGrayColor(206)
#define GetHight SCREEN_HEIGHT/667.0
#define GetWith SCREEN_WIDTH/375.0

@interface ShowImagesViewController ()<UIScrollViewDelegate,ZoomImageViewDelegate>

/** 展示UIScrollView */
@property (nonatomic, strong) UIScrollView *bigScrollView;
/** 缩略UIScrollView */
@property (nonatomic, strong) UIScrollView * showScrollView;
/** 图片工具条 */
@property (nonatomic, strong)UIView * toolView;

@property (nonatomic, strong) NSMutableArray * imageDataArray;
/** 选中的缩略图 */
@property (nonatomic, weak) UIButton *selectedBtn;
/** 当前展示的图片 */
@property (nonatomic, strong)ZoomImageView * bigCurrentImageV;
/** 镜像 */
@property (nonatomic,assign)BOOL Mirror;

@end

@implementation ShowImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.Mirror = NO;
    [self.imageDataArray addObjectsFromArray:_arr];
   
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.bigScrollView];
    [self.view addSubview:self.showScrollView];
    [self setUpImageView];
    self.toolView.backgroundColor = [UIColor blueColor];

}

//设置图片展示
- (void)setUpImageView{
    
    for (int i = 0; i < self.imageDataArray.count; i ++) {

        ZoomImageView * bigImageV = [[ZoomImageView alloc]init];
        bigImageV.sigleImageDelegate = self;
        bigImageV.tag = i + 1000;
        bigImageV.frame = CGRectMake( i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -200);
        [self.bigScrollView addSubview:bigImageV];


        UIButton * showImageBtn = [[UIButton alloc]init];
        showImageBtn.tag = i;
        UIImage * image = nil;
        if ([self.imageDataArray[i] isKindOfClass:[NSString class]]) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageDataArray[i]]]];
        }else{
            image = self.imageDataArray[i];
        }
        
        [showImageBtn setBackgroundImage:image forState:UIControlStateNormal];
        showImageBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        showImageBtn.layer.borderWidth = 0.5;
        [showImageBtn addTarget:self action:@selector(showImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [showImageBtn setBackgroundColor:GRRandomColor];
        showImageBtn.frame = CGRectMake( i * 60 + 2, 0, 60, 60);
        
        [self.showScrollView addSubview:showImageBtn];
        
    }
    //当前展示图片
    _bigCurrentImageV = _bigScrollView.subviews.firstObject;
    _bigCurrentImageV.imageURL = [self.imageDataArray objectAtIndex:0];

    UIImageView * indicatorView = [[UIImageView alloc]init];
    indicatorView.frame = CGRectMake(SCREEN_WIDTH/2.0 - 5, _showScrollView.lc_bottom + 8, 10, 10);
    indicatorView.backgroundColor = [UIColor redColor];
    [self.view addSubview:indicatorView];
 

    
    
    
    CGPoint offset = self.showScrollView.contentOffset;
    offset.x = -SCREEN_WIDTH/2.0 + 30;
    [self.showScrollView setContentOffset:offset animated:YES];

}


- (void)showImageBtn:(UIButton *)btn{
    
    [_bigScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * btn.tag, 0)];
    CGPoint offset = self.showScrollView.contentOffset;
    offset.x = -(60 * -btn.tag + SCREEN_WIDTH/2.0) + 30;
    [self.showScrollView setContentOffset:offset animated:YES];

}





-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //拖动上面的图片  下面的按钮滚动
    if(scrollView == _bigScrollView)
    {
        _showScrollView.delegate = nil;
        [_showScrollView setContentOffset:CGPointMake((_bigScrollView.contentOffset.x/SCREEN_WIDTH)* 60 - (SCREEN_WIDTH/2.0) + 30, 0)];
        NSInteger x = _bigScrollView.contentOffset.x/SCREEN_WIDTH;
        _bigScrollView.delegate = self;
        _bigCurrentImageV = (ZoomImageView *)[self.view viewWithTag:1000 + x];
        _bigCurrentImageV.imageURL = self.imageDataArray[x];

    }
    
}

- (NSMutableArray *)imageDataArray{

    if (!_imageDataArray) {
        _imageDataArray = [[NSMutableArray alloc]init];
    }
    return _imageDataArray;
}

- (UIScrollView *)bigScrollView{
    if (!_bigScrollView) {
        
        _bigScrollView = [[UIScrollView alloc]init];
        _bigScrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 200);
        _bigScrollView.pagingEnabled = YES;
        _bigScrollView.showsHorizontalScrollIndicator = NO;
        _bigScrollView.showsVerticalScrollIndicator = NO;
        _bigScrollView.delegate = self;
        _bigScrollView.contentSize = CGSizeMake(8 * SCREEN_WIDTH, 0);
        
    }
    return _bigScrollView;
}

- (UIScrollView *)showScrollView{
    if (!_showScrollView) {
        
        _showScrollView = [[UIScrollView alloc]init];
        _showScrollView.frame = CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 60);
        _showScrollView.pagingEnabled = YES;
        _showScrollView.showsHorizontalScrollIndicator = NO;
        _showScrollView.showsVerticalScrollIndicator = NO;
        _showScrollView.delegate = self;
        _showScrollView.contentSize = CGSizeMake(60 * 8, 0);
        
    }
    return _showScrollView;
}

- (UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc]init];
        _toolView.frame = CGRectMake(20, _bigScrollView.lc_bottom + 20, SCREEN_WIDTH - 40, 50);
        [self.view addSubview:_toolView];

        UIButton * rollRightBtn = [[UIButton alloc]init];
        [_toolView addSubview:rollRightBtn];
        [rollRightBtn addTarget:self action:@selector(rollRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [rollRightBtn setBackgroundImage:[UIImage imageNamed:@"icon_rotate_right"] forState:UIControlStateNormal];
        [rollRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_toolView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(_toolView);
        }];
        
        UIButton * rollLeftBtn = [[UIButton alloc]init];
        [rollLeftBtn addTarget:self action:@selector(rollLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:rollLeftBtn];
        [rollLeftBtn setBackgroundImage:[UIImage imageNamed:@"icon_rotate_left"] forState:UIControlStateNormal];
        [rollLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(rollRightBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(_toolView);
        }];
        
        UIButton * upDownBtn = [[UIButton alloc]init];
        [_toolView addSubview:upDownBtn];
        [upDownBtn addTarget:self action:@selector(upDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [upDownBtn setBackgroundImage:[UIImage imageNamed:@"icon_flipud"] forState:UIControlStateNormal];
        [upDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(rollLeftBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(_toolView);
        }];

        
        UIButton * leftRightBtn = [[UIButton alloc]init];
        [_toolView addSubview:leftRightBtn];
        [leftRightBtn addTarget:self action:@selector(leftRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [leftRightBtn setBackgroundImage:[UIImage imageNamed:@"icon_fliplr"] forState:UIControlStateNormal];
        [leftRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(upDownBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(_toolView);
        }];

        UIButton * restBtn= [[UIButton alloc]init];
        [restBtn addTarget:self action:@selector(restBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:restBtn];
        [restBtn setTitle:@"rest" forState:UIControlStateNormal];
        [restBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftRightBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(_toolView);
        }];

        
    }
    return _toolView;
}

//复位
- (void)restBtnClick{

[UIView animateWithDuration:0.15 animations:^{
    
    _bigCurrentImageV.transform = CGAffineTransformIdentity;

}];

}

//向右旋转
- (void)rollRightBtnClick{
    
    [self theViewTurn:M_PI/2];

}

//向左旋转
- (void)rollLeftBtnClick{
    
    [self theViewTurn:-M_PI/2];

}

//上下翻转
- (void)upDownBtnClick{
    
    [self theViewScale:NO];

}

//左右翻转
- (void)leftRightBtnClick{
    
    [self theViewScale:YES];

}


- (void)theViewTurn:(float)theTurn
{
    [UIView animateWithDuration:0.15 animations:^{

        _bigCurrentImageV.transform = CGAffineTransformRotate(_bigCurrentImageV.transform,theTurn);
        
        [self doTheScore];
    }];
}

- (void)doTheScore
{
    if (self.bigCurrentImageV.frame.size.width > SCREEN_WIDTH) {
        float scale = SCREEN_WIDTH/self.bigCurrentImageV.frame.size.width;
        self.bigCurrentImageV.transform = CGAffineTransformScale(self.bigCurrentImageV.transform,scale, scale);
    }else{
        float scale = SCREEN_WIDTH/self.bigCurrentImageV.frame.size.width;
        self.bigCurrentImageV.transform = CGAffineTransformScale(self.bigCurrentImageV.transform,scale, scale);

        int thePicMaxHeight = SCREEN_HEIGHT - 120 - 120;
        float theBeeImageViewHeight = SCREEN_WIDTH*self.bigCurrentImageV.frame.size.height/self.bigCurrentImageV.frame.size.width;
        float theRadio = thePicMaxHeight/theBeeImageViewHeight;
        if (theBeeImageViewHeight > thePicMaxHeight) {
            self.bigCurrentImageV.transform = CGAffineTransformScale(self.bigCurrentImageV.transform,theRadio, theRadio);
        }

    }
    
    
}

//保存图片到本地
- (void)saveImage{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存图片到相册" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_bigCurrentImageV.imageURL]]];
        NSLog(@"%@",_bigCurrentImageV.imageURL);
        [self loadImageFinished:image];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}


- (void)theViewScale:(BOOL)leftRight
{
    if (self.Mirror == YES) {
        self.Mirror = NO;
    }else{
        self.Mirror = YES;
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        
        if (leftRight == 1) {
            self.bigCurrentImageV.transform = CGAffineTransformScale(self.bigCurrentImageV.transform, -1, 1);
        }else{
            self.bigCurrentImageV.transform = CGAffineTransformScale(self.bigCurrentImageV.transform, 1, -1);
        }
        [self doTheScore];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)browseEnd{
    
    [self restBtnClick];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
