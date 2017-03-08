//
//  Spliter.h
//  HostModel
//
//  Created by mac on 16/5/12.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Solution.h"
#import "Analyser.h"

typedef struct _part
{
    void *cards;                //牌堆
    void *hasDrawCardsIndex;    //已经提取的牌的下标
}part;


@interface Spliter : NSObject

@property(nonatomic, strong)NSMutableArray<Card *> *cards;
@property(nonatomic, strong)NSMutableArray<Solution *> *solutions;          //可变动方案数组
@property(nonatomic, strong)Solution *bestSolution;                         //最佳方案

//以下是没有关系的牌的存储
@property(nonatomic, strong)NSMutableArray<HandCard *>* singles;            //单牌数组
@property(nonatomic, strong)NSMutableArray<HandCard *>* doubles;            //对子数组
@property(nonatomic, strong)NSMutableArray<HandCard *>* threes;             //三条数组
@property(nonatomic, strong)NSMutableArray<HandCard *>* bombs;              //炸弹数组

@property(nonatomic, strong)NSMutableArray<NSMutableArray *> *combArr;

- (void)splitCards;









- (id)initWithCards:(NSArray<Card *> *)cards;
- (NSRange)rangeOfCardWithValue:(NSInteger)value;
- (BOOL)isRelateWithCard:(Card *)card;

- (void)combinationAllWithNumber:(NSInteger) number;
//- (Solution *)betterSolutionWithSolutions:(NSMutableArray<Solution *> *)solutions;

//找出该牌的位置，
+ (NSRange)rangeOfCardWithValue:(NSInteger)value andTarget:(NSArray <Card *> *)cards;

@end
