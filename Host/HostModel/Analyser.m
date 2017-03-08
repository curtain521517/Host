//
//  CardKind.m
//  HostModel
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "Analyser.h"
#import "HandCard.h"

@implementation Analyser

- (void)analyseCardData:(analyseResultRef)resultRef
{
    memset(resultRef, 0, sizeof(analyseResult));
    NSInteger index = 0;
    for (NSInteger i = 0 ; i < _targetCards.count; i++) {
        NSInteger sameCount = 1;
        
        for (NSInteger j = i + 1 ; j < _targetCards.count; j++) {
            if(_targetCards[j].value == _targetCards[i].value) 
                sameCount++;
            else
                break;
        }
        //存储相应的个数，和值
        switch (sameCount) {
                case 1:
                    {
                        index = resultRef->singleCount++;
                        resultRef->singleCardData[index] = _targetCards[i].value;
                    }
                    break;
                case 2:
                    {
                        index = resultRef->doubleCount++;
                        resultRef->doubleCardData[index] = _targetCards[i].value;
                    }
                    break;
                case 3:
                    {
                        index = resultRef->threeCount++;
                        resultRef->threeCardData[index] = _targetCards[i].value;
                    }
                    break;
                case 4:
                    {
                        index = resultRef->fourCount++;
                        resultRef->fourCardData[index] = _targetCards[i].value;
                    }
                    break;
                default:
                    break;
            }
            //重置索引,因为是排过序的，所以可以直接定位下个目标
            i +=(sameCount - 1);
        }
}


- (BOOL) analyseTarget:(HandCard *)targetHandCards
{
    _targetHandCards = targetHandCards;
    _targetCards = targetHandCards.cards;
    
    _targetHandCards.length = [targetHandCards.cards count];
    _targetHandCards.bAnalyse = TRUE;
    
    switch (_targetHandCards.cards.count) {
        case 0:
            _targetHandCards.cardType = ERRORTYPE;
            return FALSE;
            //单张
        case 1:
            _targetHandCards.value = _targetHandCards.cards[0].value;
            _targetHandCards.cardType = SINGLE;
            return TRUE;
        case 2:
            //对子
            if(_targetHandCards.cards[0].value == _targetHandCards.cards[1].value) {
                _targetHandCards.value = _targetHandCards.cards[0].value;
                _targetHandCards.cardType = DOUBLE;
                return TRUE;
            }
            //王炸
            if(_targetHandCards.cards[0].value == (BIGKING) && \
               _targetHandCards.cards[1].value == (SMALLKING))
            {
                _targetHandCards.value = _targetHandCards.cards[1].value;
                _targetHandCards.cardType = BOMB;
                return TRUE;
            }
            _targetHandCards.cardType = ERRORTYPE;
            return FALSE;
        case 3:
            //三张
            if (_targetHandCards.cards[0].value == _targetHandCards.cards[1].value && \
                _targetHandCards.cards[1].value == _targetHandCards.cards[2].value) {
                _targetHandCards.value = _targetHandCards.cards[0].value;
                _targetHandCards.cardType = THREE;
                return TRUE;
            }
            _targetHandCards.cardType = THREE;
            return FALSE;
    }
    
    analyseResult result;
    [self analyseCardData:&result];
    
    //有四个相同的牌情况
    if(result.fourCount > 0) {
        //一手炸弹
        if(_targetHandCards.length == 4) {
            if(result.fourCount == 1) {
                _targetHandCards.cardType = BOMB;
                _targetHandCards.value = result.fourCardData[0];
                return TRUE;
            }
        }
        //6张牌，一个四张，2个不同的单张，四带2单张的情况
        if ((_targetHandCards.length== 6) &&  \
            result.fourCount == 1 && result.singleCount== 2) {
            _targetHandCards.cardType = BOMBWITHTWO;
            _targetHandCards.value = result.fourCardData[0];
            return TRUE;
        }
        //8张牌，一个四张，两个对子
        if ((_targetHandCards.length == 8) && \
            result.fourCount == 1 && result.doubleCount==2) {
            _targetHandCards.cardType = BOMBWITHFOUR;
            _targetHandCards.value = result.fourCardData[0];
            return TRUE;
        }
    }
    //三张的情况,
    if(result.threeCount > 0) {
        //一个三张
        if(_targetHandCards.length == 3 && result.threeCount == 1) {
            _targetHandCards.cardType = THREE;
            _targetHandCards.value = result.threeCardData[0];
            return TRUE;
        }
        //三带一
        else if(_targetHandCards.length == 4 && result.threeCount == 1 ) {
            if (result.singleCount==1) {
                _targetHandCards.cardType = THREEWITHSINGLE;
                _targetHandCards.value = result.threeCardData[0];
                return TRUE;
            }
        }
        //三带二
        else if(_targetHandCards.length == 5 && result.threeCount == 1 ) {
            if (result.doubleCount==1) {
                _targetHandCards.cardType = THREEWITHSINGLE;
                _targetHandCards.value = result.threeCardData[0];
                return TRUE;
            }
        }
        //飞机的情况
        if(result.threeCount > 1) {
            NSInteger i = 0;
            //连续判断
            for (i = 1; i < result.threeCount; i++) {
                if(result.threeCardData[i] - result.threeCardData[i-1] != -1)
                    break;
            }
            //3张中不能包有2点
            if(result.threeCardData[0] >= (SMALLKING - 1) ) {
                _targetHandCards.cardType = ERRORTYPE;
                return FALSE;
            }
            //是连续的,
            if (i == result.threeCount) {
                //飞机什么也不带
                if(_targetHandCards.length == result.threeCount * 3) {
                    _targetHandCards.cardType = FLY;
                    _targetHandCards.value = result.threeCardData[result.threeCount-1];
                    return TRUE;
                }
                //飞机带一张的情况
                if(_targetHandCards.length == result.threeCount * 4) {
                    if(result.singleCount == result.threeCount) {
                        _targetHandCards.cardType = FLYWITHSINGLE;
                        _targetHandCards.value = result.threeCardData[result.threeCount-1];
                        return TRUE;
                    }
                }
                //飞机带两张的情况
                if(_targetHandCards.length == result.threeCount * 5) {
                    if(result.doubleCount == result.threeCount) {
                        _targetHandCards.cardType = FLYWITHDOUBLE;
                        _targetHandCards.value = result.threeCardData[result.threeCount-1];
                        return TRUE;
                    }
                }
            }
        }
    }
    //连对的情况
    if(result.doubleCount >= 3) {
        NSInteger i = 0;
        //连续判断
        for (i = 1; i < result.doubleCount; i++) {
            if(result.doubleCardData[i] - result.doubleCardData[i-1] != -1)
                break;
        }
        //对子中中不能包有2点
        if(result.doubleCardData[0] >= (SMALLKING - 1) ) {
            _targetHandCards.cardType = ERRORTYPE;
            return FALSE;
        }
        //是连续的
        if(i==result.doubleCount) {
            if(_targetHandCards.length == result.doubleCount * 2) {
                _targetHandCards.cardType = SERIALDOUBLE;
                _targetHandCards.value = result.doubleCardData[result.doubleCount-1];
                return TRUE;
            }
        }
    }
    //顺子的情况
    if(result.singleCount >= 5 && result.singleCount == _targetHandCards.length) {
        NSInteger i = 0;
        //连续判断
        for (i = 1; i < result.singleCount; i++) {
            if(result.singleCardData[i] - result.singleCardData[i-1] !=-1)
                break;
        }
        //单连中不能包有2点
        if(result.singleCardData[0] >= (SMALLKING - 1) ) {
            _targetHandCards.cardType = ERRORTYPE;
            return FALSE;
        }
        //是连续的
        if(i==result.singleCount) {
            _targetHandCards.cardType = SERIALSINGLE;
            _targetHandCards.value = result.singleCardData[result.singleCount - 1];
            return TRUE;
        }
    }
    //其它情况
    _targetHandCards.cardType = ERRORTYPE;
    return FALSE;
}

@end
