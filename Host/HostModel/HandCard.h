//
//  HandCard.h
//  HostModel
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 xufan. All rights reserved.
//  一手牌
/*
 一手牌的抽象，
 主要用于描述这手牌的类型和大小，
 
 主要用于玩家出牌的包装，和自己选牌包装手牌对象从而进行比较
 */

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Analyser.h"

typedef enum _CardType
{
    SINGLE = 1,             //单张
    DOUBLE,                 //对子
    THREE,                  //三张
    SERIALSINGLE,           //连子
    SERIALDOUBLE,           //连对
    FLY,                    //飞机没有带牌
    BOMB,                   //炸弹
    THREEWITHSINGLE,        //单纯的三带一
    THREEWITHDOUBLE,        //单纯的三带二
    FLYWITHSINGLE,          //飞机带一张牌
    FLYWITHDOUBLE,          //飞机带两张牌
    BOMBWITHTWO,            //四带2张单牌
    BOMBWITHFOUR,           //四带2对牌
    ERRORTYPE,              //错误
}CardType;


@interface HandCard : NSObject

@property(nonatomic, strong)NSMutableArray<Card *> *cards;      //牌

@property(nonatomic, assign)BOOL bAnalyse;                      //是否经过了分析
@property(nonatomic, assign)NSInteger value;                    //第一张牌的值
@property(nonatomic, assign)NSInteger length;                   //长度
@property(nonatomic, assign)CardType cardType;                  //牌型


- (id)initWithCards:(NSArray<Card *> *)cards;

- (void)addCard:(Card *)card;
- (void)sortHandCard;
- (void)addHandCard:(HandCard *)handCard;

@end
