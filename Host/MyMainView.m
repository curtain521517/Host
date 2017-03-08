//
//  MyMainView.m
//  Host
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "MyMainView.h"
#import "CardImageView.h"
#define THREESCORE 203
#define TWOSCORE   202
#define ONESCORE   201
#define NOCALL     200
#define HELPBTN    204
#define PASSBTN    205
#define _SEND       206

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height

#define LEFT   2
#define RIGHT  1
#define BOTTOM 0

#define TEST

@implementation MyMainView
{
    //UIView *_outCardsView;
    NSTimer *_timer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (Controller *)controller
{
    if (!_controller) {
        _controller = [Controller DefaultController];
    }
    return _controller;
}


- (NSMutableArray<CardImageView *> *)leftCards
{
    if (!_leftCards) {
        _leftCards = [NSMutableArray array];
    }
    return _leftCards;
}

- (NSMutableArray<CardImageView *> *)rightCards
{
    if (!_rightCards) {
        _rightCards = [NSMutableArray array];
    }
    return _rightCards;
}

- (NSMutableArray<CardImageView *> *)bottomCards
{
    if (!_bottomCards) {
        _bottomCards = [NSMutableArray array];
    }
    return _bottomCards;
}

- (NSMutableArray<CardImageView *> *)hostCards
{
    if (!_hostCards) {
        _hostCards = [NSMutableArray array];
    }
    return _hostCards;
}

- (NSMutableArray<CardImageView *> *)outCards
{
    if (!_outCards) {
        _outCards = [NSMutableArray array];
    }
    return _outCards;
}

#pragma mark -UI

- (void)createUI
{
    [self createCallHostBtn];
}

- (CGRect)frameForButtonWithName:(NSString *)name
{
    CGRect rect = CGRectZero;
    CGFloat scale = 1/1.5;
    CGFloat scoreOffx = 15.0;
    CGFloat scoreOffy = HEIGHT - CARDHEIGHT-self.yStep -10-40-4;
    CGFloat width = 82;
    
    CGFloat btnOffx = 1.5*scoreOffx;

    if ([name isEqualToString:@"3分"]) {
        rect = CGRectMake(WIDTH/2 - (width*scale*2+scoreOffx*1.5), scoreOffy , 82*scale, 40*scale);
    }
    else if([name isEqualToString:@"2分"]) {
        rect = CGRectMake(WIDTH/2 - (width*scale*1+scoreOffx*0.5), scoreOffy , 82*scale, 40*scale);
    }
    else if([name isEqualToString:@"1分"]) {
        rect = CGRectMake(WIDTH/2 + (scoreOffx*0.5), scoreOffy , 82*scale, 40*scale);
    }
    else if([name isEqualToString:@"不叫"]) {
        rect = CGRectMake(WIDTH/2 + (width*scale*1+scoreOffx*1.5), scoreOffy , 82*scale, 40*scale);
    }
    //左一
    else if([name isEqualToString:@"提示"]) {
        rect = CGRectMake(WIDTH/2 - (width*scale*1.5+btnOffx), scoreOffy , 82*scale, 40*scale);
    }
    //中间
    else if([name isEqualToString:@"不出"]) {
        rect = CGRectMake(WIDTH/2 - (width*scale*0.5), scoreOffy , 82*scale, 40*scale);
    }
    //右边
    else if([name isEqualToString:@"出牌"]) {
        rect = CGRectMake(WIDTH/2 + (width*scale*0.5+btnOffx), scoreOffy , 82*scale, 40*scale);
    }


    return rect;
}

//叫地主按钮,
- (void)createCallHostBtn
{
    for (NSInteger i = 3; i >= 1; i--) {
        UIButton *btn = [UIButton buttonWithName:[NSString stringWithFormat:@"%ld分",i]];
        btn.frame = [self frameForButtonWithName:[NSString stringWithFormat:@"%ld分",i]];
        btn.tag = NOCALL + i;
        [btn addTarget:self action:@selector(callHostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    UIButton *btn = [UIButton buttonWithName:@"不叫"];
    btn.frame = [self frameForButtonWithName:@"不叫"];
    btn.tag = NOCALL;
    [self addSubview:btn];
    [btn addTarget:self action:@selector(callHostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

//出牌相关按钮
- (void)createToolBtn
{
    UIButton *btn = [UIButton buttonWithName:@"提示"];
    btn.frame = [self frameForButtonWithName:@"提示"];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = HELPBTN;
    [self addSubview:btn];
    
    btn = [UIButton buttonWithName:@"不出"];
    btn.frame = [self frameForButtonWithName:@"不出"];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = PASSBTN;
    [self addSubview:btn];
    
    btn = [UIButton buttonWithName:@"出牌"];
    btn.frame = [self frameForButtonWithName:@"出牌"];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = _SEND;
    [self addSubview:btn];
}

- (void)hideToolBtn
{
    UIView *view = [self viewWithTag:HELPBTN];
    view.hidden = YES;
    
    view = [self viewWithTag:PASSBTN];
    view.hidden = YES;
    
    view = [self viewWithTag:_SEND];
    view.hidden= YES;
}

- (void)showToolBtn
{
    UIView *view = [self viewWithTag:HELPBTN];
    view.hidden = NO;
    
    view = [self viewWithTag:PASSBTN];
    view.hidden = NO;
    
    view = [self viewWithTag:_SEND];
    view.hidden= NO;
}

- (void)removeCallHostBtn
{
    for (NSInteger i = 3; i >= 0; i--) {
        UIButton *btn = [self viewWithTag:NOCALL+i];
        [btn removeFromSuperview];
    }
}

- (void)flipHostCards
{
    if (self.hostCards.count == 3) {
        for (NSInteger i = 0; i < 3; i++) {
            self.hostCards[i].bface = TRUE;//正面
        }
    }
}

- (void)callHostBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case THREESCORE:
            NSLog(@"3分");
            [self removeCallHostBtn];
            [self flipHostCards];
            [self layoutSubviews];
            [self createToolBtn];
            [Player setHostID:1];
            [self addHostCards];
            break;
        case TWOSCORE:
            NSLog(@"2分");
            [self removeCallHostBtn];
            [self flipHostCards];
            [self layoutSubviews];
            [self createToolBtn];
            [Player setHostID:2];
            [self addHostCards];
            break;
        case ONESCORE:
            NSLog(@"1分");
            [self removeCallHostBtn];
            [self flipHostCards];
            [self layoutSubviews];
            [self createToolBtn];
            [Player setHostID:3];
            [self addHostCards];

            break;
        case NOCALL:
            NSLog(@"0分");
            break;
        default:
            break;
    }
}

#pragma mark -Runtime

- (void)startRun
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(onTimer:) userInfo:self.controller repeats:NO];
}

#pragma mark -SendCardShow

- (void)showOutCardWithTarget:(NSInteger)playid andHandCard:(HandCard *)handCard
{
    
}

#pragma mark -SendCard

- (void)removeOutCards
{
    for (UIView *view in self.outCards) {
        [view removeFromSuperview];
    }
    [self.outCards removeAllObjects];
}

- (void)btnSendCard
{
    
    HandCard *handCard = [[HandCard alloc] init];
    CGFloat stepx = 20;
    NSInteger i =0;
    CGRect frame;
    
    for (CardImageView *cardView in self.bottomCards) {
        if (cardView.braise) {
            [handCard addCard:cardView.card];
        }
    }
    NSLog(@"handCard:%@",handCard);
    [self removeOutCards];
    //计算frame 大小
    CGRect rect = CGRectMake(0, 0, CARDWIDTH + (handCard.length-1)*stepx, CARDHEIGHT);
    
    CGRect frameTemp = CGRectMake(self.frame.size.width/2 - rect.size.width/2, self.frame.size.height/2 - rect.size.height/2, rect.size.width, rect.size.height);
    
    //在数据区里删除相应的牌,还有记录相应情况
    [self.controller.players[BOTTOM] sendCardWithHandCard:handCard];
    for (NSInteger i = 0; i < self.controller.handCard.length; i++) {
        frame = CGRectMake(frameTemp.origin.x + i*stepx, frameTemp.origin.y - 40, CARDWIDTH, CARDHEIGHT);
        CardImageView *iv = [[CardImageView alloc] initWithOrigin:frame.origin];
        iv.card = self.controller.handCard.cards[i];
        iv.hidden = YES;
        [self.outCards addObject:iv];
        [self addSubview:iv];
    }
    //移动的动画效果
    i = 0;
    if (handCard.cardType != ERRORTYPE) {
        for (NSInteger j = 0 ; j < self.bottomCards.count ; j++) {
            CardImageView *cardView = self.bottomCards[j];
            if (cardView.braise) {
                [self.bottomCards removeObject:cardView];
                frame = CGRectMake(frameTemp.origin.x + i*stepx, frameTemp.origin.y - 40, CARDWIDTH, CARDHEIGHT);
                [UIView animateWithDuration:0.5 animations:^{
                    cardView.frame = frame;
                } completion:^(BOOL finished) {
                    [cardView removeFromSuperview];
                    self.outCards[i].hidden = NO;//显示出来
                }];
                i++;
                j--;
            }
        }
        //重新排列
        rect = CGRectMake(0, 0, CARDWIDTH + (self.bottomCards.count - 1)*self.xStep, CARDHEIGHT);
        frameTemp = CGRectMake(self.frame.size.width/2 - rect.size.width/2, self.bottomOrigin.y, rect.size.width, rect.size.height);
        CGPoint pt = frameTemp.origin;
        pt.x-=self.xStep;
        NSLog(@"---%ld",self.bottomCards.count);
        for (NSInteger j = 0 ; j < self.bottomCards.count; j++) {
            pt.x += self.xStep;
            frame = CGRectMake(pt.x, pt.y, CARDWIDTH, CARDHEIGHT);
            [UIView animateWithDuration:0.3 animations:^{
                self.bottomCards[j].frame = frame;
            }];
        }
    }else{
        NSLog(@"牌型非法");
    }
}

- (void)onTimer:(NSTimer *)timer
{
    Controller *controller = (Controller *)timer.userInfo;
    if (controller.isGameOver) {
        NSLog(@"gameOver");
        if (timer.isValid) {
            [timer invalidate];
        }
    }
    //是自己
    if (controller.playingID==BOTTOM + 1) {
        //关闭定时器
        if (timer.isValid) {
            [timer invalidate];
        }
        NSLog(@"该自已出牌了");
        
        [self startRun];
    }
    else if(controller.playingID == RIGHT + 1) {
        NSLog(@"该右边的出牌了");
        //关闭定时器
        if (timer.isValid) {
            [timer invalidate];
        }
        //思考
        [controller.players[RIGHT] sendCard];
        if (controller.players[RIGHT].response==PASS) {
            NSLog(@"不出牌");
        }else if(controller.players[RIGHT].response==_SEND) {
            NSLog(@"出牌");
        }
        [self startRun];
    }else if(controller.playingID == LEFT + 1) {
        NSLog(@"该左边的出牌了");
        //关闭定时器
        if (timer.isValid) {
            [timer invalidate];
        }
        //思考
        [controller.players[LEFT] sendCard];
        if (controller.players[LEFT].response==PASS) {
            NSLog(@"不出牌");
        }else if(controller.players[LEFT].response==_SEND) {
            NSLog(@"出牌");
        }
        [self startRun];
    }
    //下一家
    [controller nextPlayer];
}


#pragma mark -addHostCard

- (void)addToSelf
{
    CGFloat offy = 20;
    NSInteger pos[3]={-1,-1,-1};
    NSInteger i,j;
    CGRect frame;
    //////////////////////////////
    //首先把自己的牌移位置,重新计算坐标
    self.bottomOrigin = CGPointMake((WIDTH-(CARDWIDTH+19*self.xStep)) / 2, HEIGHT - (105+offy));
    for (NSInteger i = 0 ; i < self.bottomCards.count; i++) {
        CGPoint pt = self.bottomOrigin;
        pt.x += i*self.xStep;
        CGRect frame= CGRectMake(pt.x, pt.y, CARDWIDTH, CARDHEIGHT);
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomCards[i].frame = frame;
        }];
    }
    //插入
    for (i = 0 ; i < self.hostCards.count; i++) {
        CardImageView *ivHostCard = self.hostCards[i];
        for (j = 0; j < self.bottomCards.count; j++) {
            if ([ivHostCard.card compare:self.bottomCards[j].card] > 0) {
                pos[i] = j;
                break;
            }
        }
        //直接插入到最后面
        if (pos[i] == -1) {
            frame = self.bottomCards[j-1].frame;
            CardImageView *newCard = [[CardImageView alloc] initWithOrigin:self.hostCards[i].frame.origin];
            newCard.bcontrol = YES;
            [self insertSubview:newCard aboveSubview:self.bottomCards[j-1]];
            newCard.card = self.hostCards[i].card;
            
            CGPoint pt = frame.origin;
            pt.x+=self.xStep;
            frame.origin = pt;
            [self.bottomCards addObject:newCard];
            
            [UIView animateWithDuration:0.3 animations:^{
                newCard.frame = frame;
            } completion:^(BOOL finished) {
                newCard.braise = TRUE;
            }];
        }
        else if (pos[i]!= -1) {
            frame = self.bottomCards[pos[i]].frame;
            CardImageView *newCard = [[CardImageView alloc] initWithOrigin:self.hostCards[i].frame.origin];
            newCard.bcontrol = YES;
            [self insertSubview:newCard belowSubview:self.bottomCards[pos[i]]];
            newCard.card = self.hostCards[i].card;
            
            [self.bottomCards insertObject:newCard atIndex:pos[i]];
            [UIView animateWithDuration:0.3 animations:^{
                newCard.frame = frame;
            } completion:^(BOOL finished) {
                newCard.braise = TRUE;
            }];
            
            for (j = pos[i]+1; j < self.bottomCards.count-1; j++) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.bottomCards[j].frame = self.bottomCards[j+1].frame;
                }];
            }
            frame = self.bottomCards[j].frame;
            CGPoint pt = frame.origin;
            pt.x+=self.xStep;
            frame.origin = pt;
            self.bottomCards[j].frame = frame;
        }
    }
}

- (void)addToTarget:(NSMutableArray<CardImageView *> *)target
{
    NSInteger i,j;
    NSInteger pos[3]={-1,-1,-1};
    CGRect frame = CGRectZero;

    //find pos
    for (i = 0 ; i < self.hostCards.count; i++) {
        CardImageView *ivHostCard = self.hostCards[i];
        for (j = 0; j < target.count; j++) {
            if ([ivHostCard.card compare:target[j].card] > 0) {
                pos[i] = j;
                break;
            }
        }
    }
    //insert cardimageview
    for (NSInteger i = 0 ; i < 3; i++) {
        //位置在最后一个
        if (pos[i] == -1) {
            //最后一张牌的frame
            frame = target[target.count - 1].frame;
            CardImageView *newCard = [[CardImageView alloc] initWithOrigin:self.hostCards[i].frame.origin];
            [self insertSubview:newCard aboveSubview:target[target.count - 1]];
            newCard.card = self.hostCards[i].card;
#ifdef TEST
            newCard.bface = TRUE;
#else
            newCard.bface = FALSE;
#endif
            //加入到视图数组中去，
            [target addObject:newCard];
            //动画效果
            [UIView animateWithDuration:0.3 animations:^{
                newCard.frame = CGRectOffset(frame, 0, self.yStep);
            }];
        }
        //位置在当中的
        else if (pos[i]!= -1) {
            //该插入的地方的frame
            frame = target[pos[i]].frame;
            CardImageView *newCard = [[CardImageView alloc] initWithOrigin:self.hostCards[i].frame.origin];
            [self insertSubview:newCard belowSubview:target[pos[i]]];
            newCard.card = self.hostCards[i].card;
#ifdef TEST
            newCard.bface = TRUE;
#else
            newCard.bface = FALSE;
#endif
            [target insertObject:newCard atIndex:pos[i]];
#ifdef TEST
            //在测试的环境下，显示插入到本来应该在的地方的frame
            [UIView animateWithDuration:0.3 animations:^{
                newCard.frame = frame;
            } ];
#endif
            //非测试环境下这里直接移过去
            newCard.frame = frame;

            //牌移动
            //测试环境有有动画效果，
            //非测试环境下没有动画效果
            for (j = pos[i]+1; j < target.count-1; j++) {
#ifdef TEST
                [UIView animateWithDuration:0.5 animations:^{
                    target[j].frame = target[j+1].frame;
                }];
#endif
#ifndef TEST
                target[j].frame = target[j+1].frame;
#endif
            }
            //最后一张牌的处理,测试环境下，应该是也移到下一位，也有动画效果
            frame = target[j].frame;
#ifdef TEST
            [UIView animateWithDuration:0.7 animations:^{
                target[j].frame = CGRectOffset(frame, 0, self.yStep);
            }];
#endif
#ifndef TEST
            //非测试环境下，牌面应该是从地主区移动过来效果
            target[j].frame = self.hostCards[i].frame;
            [UIView animateWithDuration:0.6 animations:^{
                target[j].frame = CGRectOffset(frame, 0, self.yStep);
            }];
#endif
        }
    }
}
//添加地主的3张牌
- (void)addHostCards
{
    self.controller.playingID = [Player hostID];
    NSInteger hostid = [Player hostID];
    hostid--;
    if (hostid < 0) {
        NSLog(@"还没有设定地主");
        return;
    }
    //把地主的牌插进相应的玩家牌区中，动画
    //底部玩家，也就是0号玩家
    //下边
    if (hostid == BOTTOM) {
        [self addToSelf];

    }
    //左边
    else if(hostid == LEFT) {
        [self addToTarget:self.leftCards];
    }
    else if(hostid == RIGHT) {
        [self addToTarget:self.rightCards];
    }
}

- (void)btnClick:(UIButton *)sender
{
    if (self.controller.playingID != (BOTTOM + 1)) {
        return;
    }
    switch (sender.tag) {
        case HELPBTN:
            NSLog(@"提示");
            break;
        case PASSBTN:
            NSLog(@"不出");
            break;
        case _SEND:
        {
            NSLog(@"出牌");
            [self btnSendCard];
            //[self hideToolBtn];
            [self.controller nextPlayer];
            [self startRun];
        }
            break;
        default:
            break;
    }
}


- (void)initData
{
    self.xStep = 20.0;
    self.yStep = 13.0;
    self.hostStep = 15.0;

    CGFloat offx = 20.0;
    CGFloat offy = 20.0;
    CGFloat hostoffY = 30;
    CGFloat hostCardScale = 0.5;
    
    self.hostOrigin = CGPointMake((WIDTH - (CARDWIDTH*hostCardScale * 3 + self.hostStep * 2))/2, hostoffY);

    [self.controller.deck shuffleCards];
    Controller *contro = [Controller DefaultController];
    [contro sendCards];
    [self.controller.players[0] sortCards];
    [self.controller.players[1] sortCards];
    [self.controller.players[2] sortCards];
    
    //hostCards
    for (NSInteger i = 0; i < 3; i++) {
        CGPoint pt = self.hostOrigin;
        pt.x+=(self.hostStep+CARDWIDTH*hostCardScale) * i;
        CardImageView *cardImageView = [[CardImageView alloc] initWithOrigin:pt];
        [self addSubview:cardImageView];
        cardImageView.card = [contro.deck sendCard];
        cardImageView.bface = FALSE;//                  //背面
        cardImageView.scale = hostCardScale;
        [self.hostCards addObject:cardImageView];
    }
    //
    //默认开始不是地主的坐标值
    self.bottomOrigin = CGPointMake((WIDTH-(CARDWIDTH+16*self.xStep)) / 2, HEIGHT - (105+offy));
    self.rightOrigin = CGPointMake(WIDTH - (offx+CARDWIDTH), (HEIGHT- (CARDHEIGHT+19*self.yStep))/2);
    self.leftOrigin = CGPointMake(offx, (HEIGHT- (CARDHEIGHT + 19*self.yStep))/2);
    
    NSLog(@"%@",self.controller.players[0]);
    NSLog(@"%@",self.controller.players[1]);
    NSLog(@"%@",self.controller.players[2]);

    for (NSInteger i = 0 ; i < contro.players[BOTTOM].cards.count; i++) {
        CGPoint pt = self.bottomOrigin;
        pt.x += i*self.xStep;
        CardImageView *cardImageView = [[CardImageView alloc] initWithOrigin:pt];
        [self addSubview:cardImageView];
        cardImageView.card = contro.players[BOTTOM].cards[i];
        cardImageView.bcontrol = YES;
        [self.bottomCards addObject:cardImageView];
    }
    
    for (NSInteger i = 0; i < contro.players[RIGHT].cards.count; i++) {
        CGPoint pt = self.rightOrigin;
        pt.y +=i*self.yStep;
        CardImageView *cardImageView = [[CardImageView alloc] initWithOrigin:pt];
        [self addSubview:cardImageView];
        cardImageView.card = contro.players[RIGHT].cards[i];
#ifdef TEST
        cardImageView.bface = TRUE;
#else
        cardImageView.bface = FALSE;
#endif
        [self.rightCards addObject:cardImageView];
    }
    for (NSInteger i = 0; i < contro.players[LEFT].cards.count; i++) {
        CGPoint pt = self.leftOrigin;
        pt.y +=i*self.yStep;
        CardImageView *cardImageView = [[CardImageView alloc] initWithOrigin:pt];
        [self addSubview:cardImageView];
        cardImageView.card = contro.players[LEFT].cards[i];
#ifdef TEST
        cardImageView.bface = TRUE;
#else
        cardImageView.bface = FALSE;
#endif
        [self.leftCards addObject:cardImageView];
    }
    
    NSLog(@"===========================================");
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self createUI];
    }
    return self;
}


@end
