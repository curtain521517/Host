//
//  ImageSource.m
//  Host
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "ImageSource.h"

@implementation ImageSource

+ (id)sharedImageSource
{
    static id source = nil;
    if (!source) {
        source = [[ImageSource alloc] init];
    }
    return source;
}

- (UIImage *)imgCardsSrc
{
    if (!_imgCardsSrc) {
        _imgCardsSrc = [UIImage imageNamed:@"lCardBig.bmp"];
    }
    return _imgCardsSrc;
}

- (UIImage *)imgCall1
{
    if (!_imgCall1) {
        _imgCall1 = [UIImage imageNamed:@"Call1.bmp"];
    }
    return _imgCall1;
}

- (UIImage *)imgCall2
{
    if (!_imgCall2) {
        _imgCall2 = [UIImage imageNamed:@"Call2.bmp"];
    }
    return _imgCall2;
}

- (UIImage *)imgCall3
{
    if (!_imgCall3) {
        _imgCall3 = [UIImage imageNamed:@"Call3.bmp"];
    }
    return _imgCall3;
}

- (UIImage *)imgNoCall
{
    if (!_imgNoCall) {
        _imgNoCall = [UIImage imageNamed:@"NOCall.bmp"];
    }
    return _imgNoCall;
}

- (UIImage *)imgHelp
{
    if (!_imgHelp) {
        _imgHelp = [UIImage imageNamed:@"Help.bmp"];
    }
    return _imgHelp;
}

- (UIImage *)imgPass
{
    if (!_imgPass) {
        _imgPass = [UIImage imageNamed:@"Pass.bmp"];
    }
    return _imgPass;
}

- (UIImage *)imgSend
{
    if (!_imgSend) {
        _imgSend = [UIImage imageNamed:@"sendCard.bmp"];
    }
    return _imgSend;
}

- (UIImage *)imgNoSend
{
    if (!_imgNoSend) {
        _imgNoSend = [UIImage imageNamed:@"nosend.bmp"];
    }
    return _imgNoSend;
}

@end
