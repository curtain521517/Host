//
//  CardImageView.h
//  Host
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

#define CARDRECT CGRectMake(0, 0, 80, 105)
#define CARDWIDTH   80
#define CARDHEIGHT  105

@interface CardImageView : UIImageView
@property(nonatomic, strong)Card *card;
@property(nonatomic, assign)CGPoint origin;
@property(nonatomic, assign)BOOL bface;
@property(nonatomic, assign)BOOL braise;
@property(nonatomic, assign)BOOL bcontrol;
@property(nonatomic, assign)CGFloat scale; //缩放

- (instancetype)initWithOrigin:(CGPoint)origin;

@end
