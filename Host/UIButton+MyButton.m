//
//  UIButton+MyButton.m
//  Host
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "UIButton+MyButton.h"
#import "ImageSource.h"
#import "ViewController.h"
@implementation UIButton (MyButton)

+ (UIImage *)imgButtonWithName:(NSString *)name andState:(UIControlState)state
{
    CGFloat width = 82;
    CGFloat height = 40;
    CGFloat offx = 6;
    CGFloat offy = 2;
    CGRect rect;
    if (state == UIControlStateNormal) {
        rect = CGRectMake(0+offx, 0+offy, width-2*offx, height-2*offy);
    }else if(state == UIControlStateSelected) {
        rect = CGRectMake(82+offx, 0+offy, width-2*offx, height-2*offy);
    }else if (state == UIControlStateHighlighted) {
        rect = CGRectMake(82*2+offx, 0+offy, width-2*offx, height-2*offy);
    }else if(state == UIControlStateDisabled) {
        rect = CGRectMake(82*3+offx, 0+offy, width-2*offx, height-2*offy);
    }
    ImageSource *src = [ImageSource sharedImageSource];

    if ([name isEqualToString:@"3分"]) {
        UIImage *img = src.imgCall3;
        return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, rect)];
    }
    if ([name isEqualToString:@"2分"]) {
        UIImage *img = src.imgCall2;
        return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, rect)];
    }
    if ([name isEqualToString:@"1分"]) {
        UIImage *img = src.imgCall1;
        return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, rect)];
    }
    if ([name isEqualToString:@"不叫"]) {
        UIImage *img = src.imgNoCall;
        return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, rect)];
    }
    if ([name isEqualToString:@"出牌"]) {
        UIImage *img = src.imgSend;
        return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, rect)];
    }
    if ([name isEqualToString:@"提示"]) {
        UIImage *img = src.imgHelp;
        return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, rect)];
    }
    if ([name isEqualToString:@"不出"]) {
        UIImage *img = src.imgPass;
        return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, rect)];
    }
    return nil;
}

+ (instancetype)buttonWithName:(NSString *)name
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    
    [btn setImage:[UIButton imgButtonWithName:name andState:UIControlStateNormal] forState:UIControlStateNormal];
    [btn setImage:[UIButton imgButtonWithName:name andState:UIControlStateSelected] forState:UIControlStateSelected];
    [btn setImage:[UIButton imgButtonWithName:name andState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [btn setImage:[UIButton imgButtonWithName:name andState:UIControlStateDisabled] forState:UIControlStateDisabled];
    
    return btn;
}

@end
