//
//  Solution.m
//  HostModel
//
//  Created by mac on 16/5/15.
//  Copyright © 2016年 xufan. All rights reserved.
/*
 抽像描述一种拆牌方案
 主要数据结构
 {  权值，
    手数   
 }
 另外还包含一种固定的数据结构
 {
 数组一:   专门记录单张的数组
 数组二:   专门记录对子的数组
 数组三:   专门记录三张的数组
 数组四:   专门记录顺子的数组
 数组五:   专门记录连对的数组
 数组六:   专门记录飞机的数组
 数组七:   专门记录炸弹的数组
 }
 
 存放的时候，每一张都会存，如333,三条里面就存放了333, 主要是为出牌方便

 权值用来描述其价值，手数就是有几手牌，综合下来，就是权值大并且少数小，这种方案就好
 
 带的牌不记录，只是手数可以减少，这样就做到了动态带牌(只有存在单张或是对子的时候，少数可以减少，其它情况少数不减少)
 例如333 44，记录为333 44，手数1, 333 555 少数为2
 另外我们规定，炸弹通常不带牌

 */

#import "Solution.h"

@implementation Solution

@synthesize count = _count;
@synthesize value = _value;
//记算权值
/*
 单张的权值 1
 对子的权值 2
 三张的权值 3
 顺子的权值 4,每多一张权值+1
 连对的权值 5,每多一对权值+2
 飞机的权值 6,每多三条权值+3
 炸弹的权值 7,
 */

- (void)reSetflag
{
    _bSort = NO;
    _bAnalyseCount = NO;
    _bAnalyseValue = NO;
}

- (NSMutableArray<HandCard *> *)serialSingles
{
    if (!_serialSingles) {
        _serialSingles = [NSMutableArray array];
    }
    if (!_bSort) {
        [self sortSolution];
        _bSort = YES;
    }
    return _serialSingles;
}

- (NSMutableArray<HandCard *> *)serialDoubles
{
    if (!_serialDoubles) {
        _serialDoubles = [NSMutableArray array];
    }
    if (!_bSort) {
        [self sortSolution];
        _bSort = YES;
    }
    return _serialDoubles;
}

- (NSMutableArray<HandCard *> *)singles
{
    if (!_singles) {
        _singles = [NSMutableArray array];
    }
    if (!_bSort) {
        [self sortSolution];
        _bSort = YES;
    }
    return _singles;
}

- (NSMutableArray<HandCard *> *)doubles
{
    if (!_doubles) {
        _doubles = [NSMutableArray array];
    }
    if (!_bSort) {
        [self sortSolution];
        _bSort = YES;
    }
    return _doubles;
}

- (NSMutableArray<HandCard *> *)threes
{
    if (!_threes) {
        _threes = [NSMutableArray array];
    }
    if (!_bSort) {
        [self sortSolution];
        _bSort = YES;
    }
    return _threes;
}

- (NSMutableArray<HandCard *> *)bombs
{
    if (!_bombs) {
        _bombs = [NSMutableArray array];
    }
    if (!_bSort) {
        [self sortSolution];
        _bSort = YES;
    }
    return _bombs;
}

- (NSMutableArray<HandCard*> *)flys
{

    if (!_bombs) {
        _flys = [NSMutableArray array];
    }
    if (!_bSort) {
        [self sortSolution];
        _bSort = YES;
    }
    return _flys;
}

- (NSInteger)value
{
    if (!_bAnalyseValue) {
        
        _bAnalyseValue = YES;
        if (!_bSort) {
            _bSort = YES;
            [self sortSolution];
        }
        
        _value = 0;
        _value += self.singles.count;
        _value += self.doubles.count * 2;
        _value += self.threes.count * 3;
        
        for (NSInteger i = 0 ; i < self.serialSingles.count; i++) {
            _value += 4;
            _value +=self.serialSingles[i].length - 5;
        }
        
        for (NSInteger i = 0 ; i < self.serialDoubles.count; i++) {
            _value += 5;
            _value +=self.serialDoubles[i].length - 6;
        }
        
        for (NSInteger i = 0 ; i < self.flys.count; i++) {
            _value += 6;
            _value +=self.flys[i].length -= 6;
        }
        
        for (NSInteger i = 0 ; i < self.bombs.count; i++) {
            _value += 7;
        }
    }
    return _value;
}

//记算手数
/*
 主要是三带的情况麻烦,炸弹我们不考虑带牌的情况
 */
- (NSInteger)count
{
    if (!_bAnalyseCount) {
        _bAnalyseCount = YES;
        
        if (!_bSort) {
            _bSort = YES;
            [self sortSolution];
        }
        
        _count = 0;
        //单张个数
        NSInteger singleCount = self.singles.count;
        //对子个数
        NSInteger doubleCount = self.doubles.count;
        //散三条个数
        NSInteger threeCount = self.threes.count;
        
        //先计算总手数
        _count +=self.bombs.count;
        _count +=self.serialDoubles.count;
        _count +=self.serialSingles.count;
        _count +=self.singles.count;
        _count +=self.doubles.count;
        _count +=self.threes.count;
        _count +=self.flys.count;
        
        //计算带牌手数
        NSInteger subCount = 0;
        NSInteger min = singleCount < doubleCount ? singleCount : doubleCount;
        NSInteger max = singleCount > doubleCount ? singleCount : doubleCount;
        
        //分析带牌的情况
        //第一种情况，三条的数目比，单张+对子的数目还多或相等
        if(threeCount >= (singleCount + doubleCount)) {
            subCount += (singleCount + doubleCount);
        }
        //第二种情况，三条的数目,比对子+个子的手数小
        //这里，我们先让飞机去带牌，大飞机先带牌，而且是散牌多的牌
        else if (threeCount < (singleCount + doubleCount)) {
            //首先去飞机里面找, 大飞机排前面
            NSMutableArray<HandCard *> * flys = [[NSMutableArray alloc] initWithArray:self.flys];
            [flys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSInteger ret = ((HandCard *)obj2).length - ((HandCard *)obj1).length;
                if (ret < 0) {
                    return NSOrderedAscending;
                }else if(ret > 0)
                    return NSOrderedDescending;
                else return NSOrderedSame;
            }];
            //查找,大飞机先带牌，先带多的牌,即散牌多的带走
            for (NSInteger i = 0; i < flys.count; i++) {
                NSInteger flyCount = flys[i].length / 3;
                if(flyCount <= max) {
                    if(max==singleCount) {
                        //减少相应的牌数
                        singleCount -=flyCount;
                    }
                    else if(max == doubleCount) {
                        //减少相应的牌数
                        doubleCount -=flyCount;
                    }
                    //加上应该减少的手数
                    subCount +=flyCount;
                    max -= flyCount;
                    if(max < min) {
                        max = max ^min;
                        min = max ^min;
                        max = max ^min;
                    }
                }
                //飞机能带的数目大于散牌,这里有两种情况，333444555 7 8 99 / 333444555 77 88 9 /333444555 7 8 99 1010
                //不考虑折飞机的情况下,前一种情况，最少是2手牌，后一种，最少是3手牌，最后一种最少3手牌，减去单张就是该手牌数量
                //折飞机不是本类的任务
                //备用，测试，
                else if (flyCount > max) {
                    //单牌多
                    if(max == singleCount) {
                        //单牌带走了
                        subCount +=singleCount;
                    }
                    //对子多
                    else if(max == doubleCount) {
                        //单牌带走了，对子带一个留一个，相当于没变
                        subCount +=singleCount;
                    }
                }
            }//飞机找完了
            //三条再去带牌
            //有多少三条，就可以带多少手牌
            if(threeCount <= (singleCount + doubleCount)) {
                subCount +=threeCount;
            }
            //三条太多了
            else if (threeCount > (singleCount + doubleCount)) {
                subCount +=(singleCount + doubleCount);
            }
        }
        //减去带牌的数目
        _count -=subCount;
    }
    
    return _count;
}

//对自己的分类牌进行排序，大小顺序
//从大到小排序
- (void)sortSolution
{
    //从大到小排序
    if (_bombs) {
        [_bombs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HandCard *handCard1 = obj1;
            HandCard *handCard2 = obj2;
            return handCard2.value - handCard1.value;
        }];
    }
    //大飞机排前面，再按值排序
    if (_flys) {
        [_flys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HandCard *handCard1 = obj1;
            HandCard *handCard2 = obj2;
            NSInteger ret = handCard2.length - handCard1.length;
            if (ret == 0) {
                return handCard2.value - handCard1.value;
            }
            return ret;
        }];
    }
    //大对子放前面，再按值排序
    if (_serialDoubles) {
        [_serialDoubles sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HandCard *handCard1 = obj1;
            HandCard *handCard2 = obj2;
            
            NSInteger ret = handCard2.length - handCard1.length;
            if (ret == 0) {
                return handCard2.value - handCard1.value;
            }
            return ret;
        }];
    }
    //大连子放前面，再按值排序
    if (_serialSingles) {
        [_serialSingles sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HandCard *handCard1 = obj1;
            HandCard *handCard2 = obj2;
            
            NSInteger ret = handCard2.length - handCard1.length;
            if (ret == 0) {
                return handCard2.value - handCard1.value;
            }
            return ret;
        }];
    }
    //三条按值大小排序
    if (_threes) {
        [_threes sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HandCard *handCard1 = obj1;
            HandCard *handCard2 = obj2;

            return handCard2.value - handCard1.value;
        }];
    }
    //对子按值大小排序
    if (_doubles) {
        [_doubles sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HandCard *handCard1 = obj1;
            HandCard *handCard2 = obj2;
            
            return handCard2.value - handCard1.value;
        }];
    }
    //对子按值大小排序
    if (_singles) {
        [_singles sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HandCard *handCard1 = obj1;
            HandCard *handCard2 = obj2;
            return handCard2.value - handCard1.value;
        }];
    }
}

- (NSString *)description
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"{ "];
    
    for (HandCard *handCard in _bombs) {
        [strM appendFormat:@"%@ ",handCard];
    }
    for (HandCard *handCard in _flys) {
        [strM appendFormat:@"%@ ",handCard];
    }
    
    for (HandCard *handCard in _serialDoubles) {
        [strM appendFormat:@"%@ ",handCard];
    }
    
    for (HandCard *handCard in _serialSingles) {
        [strM appendFormat:@"%@ ",handCard];
    }
    
    for (HandCard *handCard in _threes) {
        [strM appendFormat:@"%@ ",handCard];
    }
    
    for (HandCard *handCard in _doubles) {
        [strM appendFormat:@"%@ ",handCard];
    }
    for (HandCard *handCard in _singles) {
        [strM appendFormat:@"%@ ",handCard];
    }
    [strM appendString:@" }"];
    [strM appendFormat:@"{ 手数:%ld, 权值:%ld }", self.count,self.value];
    return strM;
}





@end
