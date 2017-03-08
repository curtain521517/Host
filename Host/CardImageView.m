//
//  CardImageView.m
//  Host
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "CardImageView.h"
#import "ImageSource.h"

#define raiseY 18

@implementation CardImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithOrigin:(CGPoint)origin
{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, CARDWIDTH, CARDHEIGHT)];
    if (self) {
        self.bounds = CARDRECT;
        self.layer.cornerRadius = 7;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeCenter;
        _bface = TRUE;
        _braise = FALSE;
        _scale = 1.0;
    }
    return self;
}

- (CGImageRef)imgRefCardWithCard:(Card *)card
{
    NSInteger row = card.color;
    if (row < 4) {
        row = 3 - row;
    }
    
    NSInteger col = card.value;
    if (col >=14 && col < 16) {
        col = col-14;
    }else if(col < 14){
        col = col - 1;
    }else {
        col = col-16;
    }
    ImageSource *src = [ImageSource sharedImageSource];
    
    CGImageRef imgRef = src.imgCardsSrc.CGImage;
    CGImageRef imgRet = CGImageCreateWithImageInRect(imgRef, CGRectMake(col*80, row*105, 80, 105));
    return imgRet;
}

- (UIImage *)imageCard:(Card *)card
{
    return [UIImage imageWithCGImage:[self imgRefCardWithCard:card]];
}

- (void)setOrigin:(CGPoint)origin
{
    _origin = origin;
    self.frame = CGRectMake(origin.x, origin.y, CARDWIDTH, CARDHEIGHT);
}

- (void)setBface:(BOOL)bface
{
    _bface = bface;
    if (bface == TRUE) {
        self.image = [self imageCard:self.card];
    }else {
        ImageSource *src = [ImageSource sharedImageSource];
        CGImageRef imgRef = src.imgCardsSrc.CGImage;
        CGImageRef imgRet = CGImageCreateWithImageInRect(imgRef, CGRectMake(2*80, 4*105, 80, 105));
        self.image  = [UIImage imageWithCGImage:imgRet];
    }
}

- (void)setBraise:(BOOL)braise
{
    CGRect frame = self.frame;
    //从下面升起
    if (braise && !_braise) {
        _braise = braise;
        frame = CGRectOffset(frame, 0, -raiseY);
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
        return;
    }
    //从升起到下落
    if (!braise && _braise) {
        _braise = braise;
        frame = CGRectOffset(frame, 0, raiseY);
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
    }
}

- (void)setBcontrol:(BOOL)bcontrol
{
    if (!_bcontrol && bcontrol) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGesture];
        _bcontrol = bcontrol;
    }
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;

    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, CARDWIDTH*scale, CARDHEIGHT*scale);
    self.layer.cornerRadius *=scale;
    self.contentMode = UIViewContentModeScaleToFill;
}

- (void)setCard:(Card *)card
{
    _card = card;
    self.image = [self imageCard:card];
}

- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    self.braise = !self.braise;
}

@end
