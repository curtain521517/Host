//
//  ComputerAI.m
//  Host
//
//  Created by mac on 16/5/29.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "ComputerAI.h"
#import "Controller.h"
#import "Solution.h"

@implementation ComputerAI

- (Spliter *)spliter
{
    if (!_spliter) {
        _spliter = [[Spliter alloc] init];
    }
    return _spliter;
}

- (Evaluater *)evaluater
{
    if (!_evaluater) {
        _evaluater = [[Evaluater alloc] init];
    }
    return _evaluater;
}


- (BOOL)thinkPlayWithCards:(NSArray<Card *> *)cards resultHandCard:(HandCard **)result
{
    BOOL bFind = NO;
    self.spliter.cards = [NSMutableArray arrayWithArray:cards];
    Controller *controller = [Controller DefaultController];
    HandCard *destHandCard = [[Controller DefaultController] handCard];
    [_spliter splitCards];
    Solution *best = _spliter.bestSolution;
    if (destHandCard.cardType==SINGLE) {
        if (best.singles.count) {
            for (NSInteger i = best.singles.count - 1; i > 0; i--) {
                if (best.singles[i].value > destHandCard.value) {
                    *result = best.singles[i];
                    bFind = YES;
                }
            }
        }
        
    }else if(destHandCard.cardType == DOUBLE) {
        if (best.doubles.count) {
            for (NSInteger i = best.doubles.count - 1; i > 0; i--) {
                if (best.doubles[i].value > destHandCard.value) {
                    *result = best.doubles[i];
                    bFind = YES;
                }
            }
        }
        
    }else if(destHandCard.cardType == THREE) {
        if (best.threes.count) {
            for (NSInteger i = best.threes.count - 1; i > 0; i--) {
                if (best.threes[i].value > destHandCard.value) {
                    *result = best.threes[i];
                    bFind = YES;
                }
            }
        }
    }
    return bFind;
}


- (NSInteger)judgeCards:(NSArray<Card *> *)cards
{
    Evaluater *evaluate = [[Evaluater alloc] initWithCards:cards];
    
    return 1;
}


@end
