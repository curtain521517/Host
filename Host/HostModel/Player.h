//
//  Player.h
//  HostModel
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "HandCard.h"
#import "Controller.h"
#import "ThinkPlayCardPro.h"
#import "JudgeCardsPro.h"

#define PASS    1           //不出牌
#define SEND    2           //出牌
#define NORESPOND 0         //没有回应

#define FRIEND  1           //友方
#define ENEMY   2           //敌方


@interface Player : NSObject

@property(nonatomic, strong)NSMutableArray<Card *>* cards;            //牌
@property(nonatomic, assign)NSInteger nID;                            //编号
@property(nonatomic, strong)NSMutableArray<HandCard*>* handCards;     //手牌数组
@property(nonatomic, assign)NSInteger response;                       //玩家回应,0还在思考中，1出牌，2不出

@property(nonatomic, strong)id<ThinkPlayCardPro,JudgeCardsPro> thinker; //会思考的电脑算法

- (instancetype)initWithID:(NSInteger)nID;

+ (void)setHostID:(NSInteger)nID;
+ (NSInteger)hostID;
- (BOOL)isHost;

//起牌
- (void)getCard:(Card *)card;

//排序牌,即清牌
- (void)sortCards;

//内部调用出牌，主要用于数据记录
- (void)sendCardWithHandCard:(HandCard *)handCard;
//出牌
- (void)sendCard;

//不出牌
- (void)pass;

//叫地主
- (void)callHost;

//不叫地主
- (void)noCallHost;

@end
