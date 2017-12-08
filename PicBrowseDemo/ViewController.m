//
//  ViewController.m
//  PicBrowseDemo
//
//  Created by MoneyLee on 2017/12/2.
//  Copyright © 2017年 MoneyLee. All rights reserved.
//

#import "ViewController.h"
#import "ShowImagesViewController.h"
@interface ViewController ()

@property (nonatomic,strong)NSArray * imageArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * image1 = [UIImage imageNamed:@"1"];
    _imageArr = @[image1,
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1512371303&di=2110b3a1c794be9bfb1c789c01cfa240&src=http://img1b.xgo-img.com.cn/pics/1699/1698907.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1512371303&di=3d5f9066dd9c7e8e7ea2cd0190f441c7&src=http://img.xgo-img.com.cn/pics/1485/a1484505.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1512371303&di=664e8071187a2ec6a53da40bac39ae8b&src=http://image.tianjimedia.com/uploadImages/2012/231/21/B63357UG5RHC.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1512371303&di=f6515240f2f0252cd388380bc40a3588&src=http://img1a.xgo-img.com.cn/pics/1662/1661256.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1512371303&di=33673230665cca2c8267957af23d051d&src=http://pic6.wed114.cn/20131122/20131122163206876.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1512372284&di=ad74f18433ebda562f48c8b61bff4bac&src=http://img.sucai.redocn.com/attachments/images/201111/20111125/Redocn_2011112308485350.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512732303077&di=30070cdc7bf872eb64d9f1138c421bda&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F9825bc315c6034a88f134c6cc11349540823766e.jpg"];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    label.text = @"点击屏幕";
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ShowImagesViewController * vc =  [[ShowImagesViewController alloc]init];
    vc.arr = _imageArr;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
