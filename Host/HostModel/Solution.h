//
//  Solution.h
//  HostModel
//
//  Created by mac on 16/5/15.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandCard.h"


@interface Solution : NSObject

@property(nonatomic, strong)NSMutableArray<HandCard *>* singles;            //单牌数组
@property(nonatomic, strong)NSMutableArray<HandCard *>* doubles;            //对子数组
@property(nonatomic, strong)NSMutableArray<HandCard *>* threes;             //三条数组
@property(nonatomic, strong)NSMutableArray<HandCard *>* serialSingles;      //顺子数组
@property(nonatomic, strong)NSMutableArray<HandCard *>* serialDoubles;      //连对数组
@property(nonatomic, strong)NSMutableArray<HandCard *>* flys;               //飞机数组
@property(nonatomic, strong)NSMutableArray<HandCard *>* bombs;              //炸弹数组

@property(nonatomic, readonly, assign)NSInteger count;                      //权值
@property(nonatomic, readonly, assign)NSInteger value;                      //手数，几手牌

@property(nonatomic, assign, readonly)BOOL bAnalyseValue;
@property(nonatomic, assign, readonly)BOOL bAnalyseCount;
@property(nonatomic, assign, readonly)BOOL bSort;

- (void)reSetflag;

- (void)sortSolution;

@end
