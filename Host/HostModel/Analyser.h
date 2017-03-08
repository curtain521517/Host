//
//  Analyser.h
//  HostModel
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 xufan. All rights reserved.
// 牌型分析

#import <Foundation/Foundation.h>
#import "Card.h"

@class HandCard;
#define MAX_COUNT 20

typedef struct _analyseResult
{
    NSInteger singleCount;                  //记录单张数目
    NSInteger doubleCount;                  //记录双张数目
    NSInteger threeCount;                   //记录三张数目
    NSInteger fourCount;                    //记录四张数目
    
    NSInteger singleCardData[MAX_COUNT];    //记录单张的牌值value
    NSInteger doubleCardData[MAX_COUNT];    //记录对子的牌值value
    NSInteger threeCardData[MAX_COUNT];     //记录三条的牌值value
    NSInteger fourCardData[MAX_COUNT];      //记录四张的牌值value
}analyseResult, *analyseResultRef;


@interface Analyser : NSObject
{
    @private
    NSArray<Card *>* _targetCards;          //单纯的牌
    HandCard * _targetHandCards;            //手牌对像
}

//返回结果是否合法，分析一手牌的类型，大小
- (BOOL)analyseTarget:(HandCard *)targetHandCards;

@end
