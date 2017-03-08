//
//  ImageSource.h
//  Host
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageSource : NSObject

@property(nonatomic, strong)UIImage *imgCardsSrc;
@property(nonatomic, strong)UIImage *imgCall1;
@property(nonatomic, strong)UIImage *imgCall2;
@property(nonatomic, strong)UIImage *imgCall3;
@property(nonatomic, strong)UIImage *imgNoCall;     //不叫
@property(nonatomic, strong)UIImage *imgHelp;       //提示
@property(nonatomic, strong)UIImage *imgPass;       //不出
@property(nonatomic, strong)UIImage *imgSend;       //出牌
@property(nonatomic, strong)UIImage *imgNoSend;     //不出

+ (id)sharedImageSource;

@end
