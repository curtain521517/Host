//
//  ViewController.m
//  Host
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "ViewController.h"
#import "MyMainView.h"
#import "ImageSource.h"
@interface ViewController ()

@property(nonatomic, strong)UIImage *imgCardSrc;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MyMainView *view = [[MyMainView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ReviewBk.bmp"]];
    view.tag = MAINVIEWTAG;
    
    UIImageView *bgIv = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgIv.image = [UIImage imageNamed:@"ReviewBk.bmp"];
    
    [self.view addSubview:bgIv];
    [self createRotatedUI];
    [self.view addSubview:view];
}

- (void)createRotatedUI
{
    
    CGPoint pt = self.view.center;
    UIImageView *bgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 105)];
    bgView1.layer.cornerRadius = 7.0;
    bgView1.layer.masksToBounds = YES;
    ImageSource *src = [ImageSource sharedImageSource];
    pt.y-=40;
    pt.x-=42;
    CGImageRef imgRef = src.imgCardsSrc.CGImage;
    CGImageRef img1Ref = CGImageCreateWithImageInRect(imgRef, CGRectMake(2*80, 4*105, 80, 105));
    UIImage *img1 =  [UIImage imageWithCGImage:img1Ref];
    bgView1.image = [self rotatedImage:img1 WithDegrees:30];
    bgView1.center = pt;
    [self.view addSubview:bgView1];
    
    UIImageView *bgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 105)];
    bgView2.layer.cornerRadius = 7.0;
    bgView2.layer.masksToBounds = YES;
    pt = self.view.center;
    pt.y -=40;
    pt.x +=42;
    
    CGImageRef img2Ref = CGImageCreateWithImageInRect(imgRef, CGRectMake(3*80, 4*105, 80, 105));
    UIImage *img2 =  [UIImage imageWithCGImage:img2Ref];
    bgView2.image = [self rotatedImage:img2 WithDegrees:360-30];
    bgView2.center = pt;
    [self.view addSubview:bgView2];
    
}

- (UIImage *)rotatedImage:(UIImage *)img WithRadians:(CGFloat)radians
{
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    CGRect rotatedRect = CGRectApplyAffineTransform(CGRectMake(0, 0, img.size.width, img.size.height), t);
    CGSize rotatedSize = rotatedRect.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(ctx, radians);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextDrawImage(ctx, CGRectMake(-img.size.width/2, -img.size.height/2, img.size.width, img.size.height), img.CGImage);
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}

- (UIImage *)rotatedImage:(UIImage *)img WithDegrees:(CGFloat)degrees
{
    return [self rotatedImage:img WithRadians:degrees*M_PI/180];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
