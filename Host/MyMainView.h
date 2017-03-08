//
//  MyMainView.h
//  Host
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "Controller.h"
#import "UIButton+MyButton.h"
#import "Player.h"

@class CardImageView;


@interface MyMainView : UIView


@property(nonatomic, assign)CGFloat xStep;
@property(nonatomic, assign)CGFloat yStep;
@property(nonatomic, assign)CGFloat hostStep;
@property(nonatomic, assign)CGPoint leftOrigin;
@property(nonatomic, assign)CGPoint rightOrigin;
@property(nonatomic, assign)CGPoint bottomOrigin;
@property(nonatomic, assign)CGPoint hostOrigin;

@property(nonatomic, strong)Controller *controller;
@property(nonatomic, strong)NSMutableArray<CardImageView *> *bottomCards;
@property(nonatomic, strong)NSMutableArray<CardImageView *> *leftCards;
@property(nonatomic, strong)NSMutableArray<CardImageView *> *rightCards;
@property(nonatomic, strong)NSMutableArray<CardImageView *> *hostCards;
@property(nonatomic, strong)NSMutableArray<CardImageView *> *outCards;


@end
