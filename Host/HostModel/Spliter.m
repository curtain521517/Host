//
//  Spliter.m
//  HostModel
//
//  Created by mac on 16/5/12.
//  Copyright © 2016年 xufan. All rights reserved.
//
//
/*
 折分方案的类
 主要数据结构，包含了一个方案集合，还有一堆待折分的牌
 最终我们从方案中选出少数少，权值高的方案，做为分牌方案
 
 小王 222 AA QQQ J 10 987 66 5 44
 
 折牌原则
 1.首先，找出一幅牌中只能组成一种牌型的牌，与其它牌没有关联的牌（与其它牌组成顺子，连对）
 可以找出 小王 222 AAA  余下的就是QQQ J 10 987 66 5 44
 
 2.折分其它的牌顺序如下
{
    临时拆分
 
    1.先找出牌中的炸弹
    2.找出牌中所有的三条
    3.找出牌中所有的对子
}
 可以提出 QQQ 66 44 
 余下的就是 J 10 9 8 7 5
 每次我们提取余下牌中的5张连牌，然后拿这5张连牌和余下的依次拼接看能否组合成更长的连牌，提出牌后，余下的牌全部看成是单牌
 
 1.提取QQQ
 第一次 45678 余下的4 6 9 10 J
 第二次 45678910J 4 6
 最后两张牌没有联系，一次折牌结束
 方案为: 45678910J 4,6, QQQ        7+1+1+3=12 3
 
 2.提取QQQ,66
 方案为: QQQ 66 78910J 5 44        3+2+4+1+2=12 4
 
 3.提取QQQ,44
 方案为: QQQ 44 5678910J 6         3+2+6+1=12 3
 
 4.提取QQQ,66,44
 方案为: QQQ 66 44 78910J 5        3+2+2+4+1=12 4
 
 5.提取66
 方案为:QQ 66 45678910JQ 4 6       2+2+8+1+1=14 5
 
 6.提取44
 方案为:QQ 44 45678910JQ 6         2+2+8+1=13 4
 
 7.提取66 44
 方案为:QQ 66 44 5 78910J          2+2+2+1+4=11 5
 
 8.什么也不提
 方案为:45678910JQ 4 6 QQ          8+1+1+2=12 4
 */


#import "Spliter.h"

@implementation Spliter


- (id)initWithCards:(NSArray<Card *> *)cards
{
    self = [super init];
    if (self) {
        self.cards = [NSMutableArray arrayWithArray:cards];
    }
    return self;
}

- (NSMutableArray<HandCard *> *)singles
{
    if(!_singles){
        _singles = [[NSMutableArray alloc] init];
    }
    return _singles;
}

- (NSMutableArray<HandCard *> *)doubles
{
    if(!_doubles){
        _doubles = [[NSMutableArray alloc] init];
    }
    return _doubles;
}

- (NSMutableArray<HandCard *> *)threes
{
    if (!_threes) {
        _threes = [[NSMutableArray alloc] init];
    }
    return _threes;
}

- (NSMutableArray<HandCard *> *)bombs
{
    if(!_bombs) {
        _bombs = [[NSMutableArray alloc] init];
    }
    return _bombs;
}

//找出该牌的位置，
- (NSRange)rangeOfCardWithValue:(NSInteger)value
{
    NSRange range={0,0};
    for (NSInteger i = 0 ; i < self.cards.count; i++) {
        if(self.cards[i].value == value) {
            range.length++;
            range.location = i;
        }
    }
    
    if(range.length > 0)
    {
        range.location = range.location + 1 - range.length;
    }else range.location = NSNotFound;
    
    return range;
}
//找出该牌的位置，
+ (NSRange)rangeOfCardWithValue:(NSInteger)value andTarget:(NSArray <Card *> *)cards
{
    NSRange range={0,0};
    for (NSInteger i = 0 ; i < cards.count; i++) {
        if(cards[i].value == value) {
            range.length++;
            range.location = i;
        }
    }
    
    if(range.length > 0)
    {
        range.location = range.location + 1 - range.length;
    }else range.location = NSNotFound;
    
    return range;
}

//找出该牌的位置，
- (NSRange)rangeOfCardWithValue:(NSInteger)value andTarget:(NSArray <Card *> *)cards
{
    NSRange range={0,0};
    for (NSInteger i = 0 ; i < cards.count; i++) {
        if(cards[i].value == value) {
            range.length++;
            range.location = i;
        }
    }
    
    if(range.length > 0)
    {
        range.location = range.location + 1 - range.length;
    }else range.location = NSNotFound;
    
    return range;
}

- (Card *)cardOfCardWithValue:(NSInteger)value
{
    NSRange range = [self rangeOfCardWithValue:value];
    if(range.location != NSNotFound){
        return self.cards[range.location];
    }
    return nil;
}

- (Card *)cardOfCardWithValue:(NSInteger)value andTarget:(NSArray<Card *> *)cards
{
    NSRange range = [self rangeOfCardWithValue:value andTarget:cards];
    if(range.location != NSNotFound){
        return cards[range.location];
    }
    return nil;
}

//不是连对，顺子里面的牌，就是没有关系的，
- (BOOL)isRelateWithCard:(Card *)card
{
    NSRange range = [self rangeOfCardWithValue:card.value];
    if(range.location == NSNotFound)
        return FALSE;
    //大王，小王，2点,直接返回FALSE
    if(card.value==SMALLKING || card.value == BIGKING || card.value == (SMALLKING -  1))
        return FALSE;
    
    //大于两张,先分析有没有连对的情况
    //假设目标牌为A,相应别的两对为B,C,
    //对子情况，直接分析
    if (range.length >= 2) {
        
        //第一种 ABC 位置情况,牌面最少为3,最大Q 12
        if( (card.value >= 3 && card.value <= 12) && [self rangeOfCardWithValue:card.value+1].length >=2 && \
           [self rangeOfCardWithValue:card.value+2].length >=2) {
            return TRUE;
        }
        //第二种 BAC 位置情况,牌面最少为4,最大K 13
        if( (card.value >= 4 && card.value <= 13) && [self rangeOfCardWithValue:card.value-1].length >=2 && \
           [self rangeOfCardWithValue:card.value+1].length >=2) {
            return TRUE;
        }
        //第三种 BCA 位置情况,牌面最少为5,最大A 14
        if( (card.value >= 5 && card.value <= 14) && [self rangeOfCardWithValue:card.value-2].length >=2 && \
           [self rangeOfCardWithValue:card.value-1].length >=2) {
            return TRUE;
        }
    }
    //再分析有没有顺子的情况,连对中没有2
    NSInteger step = 0;
    for (NSInteger value = 14; value >= 3; value--) {
        //存在这个牌
        if([self rangeOfCardWithValue:value].location != NSNotFound) {
            step++;
            //有5张连续的，并具小于或等于给定牌的值，就表示这张牌在连子当中
            if(step >= 5 && value <= card.value) {
                return TRUE;
            }
        }
        else {
            step = 0;
            //连续断开了，并且搜索到的已经过了这张牌的牌值位置，表示这张牌不在连子中
            if(value < card.value)
                return FALSE;
        }
    }
    return FALSE;
}

- (void)clear
{
    [self.singles removeAllObjects];
    [self.doubles removeAllObjects];
    [self.threes removeAllObjects];
    [self.bombs removeAllObjects];
}

//找出没有关系的牌
//
- (BOOL)findNoRelationCard
{
    if(self.cards.count == 0)
        return FALSE;
    
    BOOL bFind = FALSE;

    //有一种特殊情况,大王和小王同时存在,炸弹,先判断这种情况
    if(self.cards.count >= 2) {
        if (self.cards[0].value==BIGKING && self.cards[1].value == SMALLKING) {
            //把王炸这手牌添加进不可变炸弹组
            HandCard *handCard = [[HandCard alloc] init];
            [handCard addCard:self.cards[0]];
            [handCard addCard:self.cards[1]];
            [self.bombs addObject:handCard];
            
            [self.cards removeObject:self.cards[0]];
            [self.cards removeObject:self.cards[0]];
            NSLog(@"find Cards:%@",handCard);
            
            bFind = TRUE;
        }
    }
    
    NSMutableIndexSet *indexset = [NSMutableIndexSet indexSet];
    //按牌值大到小遍历
    for (NSInteger i = 0 ; i < self.cards.count ; i++) {
        //如果没有关系
        if (![self isRelateWithCard:self.cards[i]]) {
            
            bFind = TRUE;
            //找到该牌的位置，数目
            NSRange range = [self rangeOfCardWithValue:self.cards[i].value];
            HandCard *handCard = [[HandCard alloc] init];
            //把这些牌添加进去
            for (NSInteger j = i ; j < i + range.length; j++) {
                [handCard addCard:self.cards[j]];
                [indexset addIndex:j];
            }
            //直接定位下一张不同的牌
            //没有关系的牌添加进相应的组里面
            if(range.length == 1) {
                [self.singles addObject:handCard];
            }else if(range.length == 2) {
                [self.doubles addObject:handCard];
            }else if(range.length == 3) {
                [self.threes addObject:handCard];
            }else if(range.length == 4) {
                [self.bombs addObject:handCard];
            }
            
            NSLog(@"findNoRelationCard:%@",handCard);
            i += range.length - 1;
        }
    }
    //移除这些拆出了的牌
    if(bFind) {
        [self.cards removeObjectsAtIndexes:indexset];
    }
    return bFind;
}

/*折分牌
首先折分没有关系的牌
折分其它的牌顺序如下
    
1.先找出牌中的炸弹
2.找出牌中所有的三条
3.找出牌中所有的对子
 
组合权值,手数计算
*/
- (void)splitCards
{
    //折牌原则
    //1.首先，找出一幅牌中只能组成一种牌型的牌，与其它牌没有关联的牌（与其它牌组成顺子，连对）
    BOOL bret = [self findNoRelationCard];
    if(!bret) {
        NSLog(@"Not Find");
    }
    //2.接着提取出里面如下的牌型
    //提出里面的炸弹，
    //提出里面的三条
    //提出里面的对子

    if ([self.cards count] == 0) {
        return;
    }
    
    
    NSMutableString *strM  = [NSMutableString string];
    for (NSInteger i = 0 ; i< self.cards.count; i++) {
        [strM appendFormat:@"%@",self.cards[i]];
    }
    NSLog(@"RelationCards:\n%@",strM);
    
    
    NSMutableArray<HandCard *> *bombs = [[NSMutableArray alloc] init];
    NSMutableArray<HandCard *> *threes = [[NSMutableArray alloc] init];
    NSMutableArray<HandCard *> *doubles = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < self.cards.count; i++) {
        //查找
        NSRange range = [self rangeOfCardWithValue:self.cards[i].value];
        //找出里面的炸弹
        if(range.length == 4) {
            HandCard *handCard = [[HandCard alloc] init];
            for (NSInteger j = i ; j < i + 4; j++) {
                [handCard addCard:self.cards[j]];
            }
            [bombs addObject:handCard];
            NSLog(@"%@",handCard);
            i = i + 3;
        }
        //找出里面的三条
        else if(range.length == 3) {
            HandCard *handCard = [[HandCard alloc] init];
            for (NSInteger j = i ; j < i + 3; j++) {
                [handCard addCard:self.cards[j]];
            }
             NSLog(@"%@",handCard);
            [threes addObject:handCard];
            i = i+2;
        }
        //找出里面的对子
        else if(range.length == 2) {
            HandCard *handCard = [[HandCard alloc] init];
            [handCard addCard:self.cards[i]];
            [handCard addCard:self.cards[i+1]];
            [doubles addObject:handCard];
            NSLog(@"%@",handCard);
            i = i+1;
        }
    }
    //剔除了没关系后的牌
    NSArray<Card *> *originCards = [[NSArray alloc] initWithArray:self.cards];
    //在步骤2中,我们排列组合提取一手牌,如，对子，三条，是一手一手的提，不是提一张
    //可以提出 QQQ 66 44
    //余下的就是 J 10 9 8 7 5
    //每次我们提取余下牌中的5张连牌，然后拿这5张连牌和余下的依次拼接看能否组合成更长的连牌，提出牌后，余下的牌全部看成是单牌
    
    //我们把有关系的牌放进一个数组里
    NSMutableArray<HandCard *> *relationHandCards = [NSMutableArray array];
    [relationHandCards addObjectsFromArray:bombs];
    [relationHandCards addObjectsFromArray:threes];
    [relationHandCards addObjectsFromArray:doubles];
    
    //计算组合方案
    [self combinationAllWithNumber:relationHandCards.count];

    //提取的手牌数组
    NSMutableArray<HandCard *> *darwHandCards = [NSMutableArray array];
    NSMutableArray<Card *> *cards = [NSMutableArray array];
    NSMutableArray<Solution *> *solutions = [NSMutableArray array];
    //循环遍历每一种组合方案
    NSInteger count = 0;
    for (NSArray *arr in self.combArr) {
        NSLog(@"----%ld,start DrawHandCards",++count);
        //对每一种方案提取牌
        //删除之前加进来的无素
        [darwHandCards removeAllObjects];
        
        //删除之前的元素，并且重新添加那些要分析的牌
        [cards removeAllObjects];
        [cards addObjectsFromArray:originCards];
        for (NSInteger i = 0 ; i < arr.count; i++) {
            //提一手牌
            HandCard *handCard = relationHandCards[[arr[i] integerValue] - 1];
            [darwHandCards addObject:handCard];
            NSLog(@"drawHandCards:%@",handCard);
            
            //从牌里面删除提取的这些牌
            for (NSInteger j = 0 ; j < handCard.cards.count; j++) {
                [cards removeObject:handCard.cards[j]];
            }
        }
        //牌提完了,根据提出的牌和剩下的牌,进行组合方案
        Solution *solution = [self combSolutionWithcards:cards andDarwHandCards:darwHandCards];
        //添加进方案组
        [solutions addObject:solution];
    }
    
    //什么也不提取，直接组牌
    Solution * solution = [self combSolutionWithcards:originCards andDarwHandCards:nil];
    [solutions addObject:solution];
    NSLog(@"----SolutionCount:%ld",[solutions count]);
    NSLog(@"----RelationCards:\n%@",strM);
    solution = [self betterSolutionWithSolutions:solutions];
    self.bestSolution = solution;
    NSLog(@"----Best Solution:%@",solution);
}

//对方案中的方案提取 最低少数, 最高权值 的那种方案
- (Solution *)betterSolutionWithSolutions:(NSMutableArray<Solution *> *)solutions
{
    if ([solutions count] == 0) {
        return nil;
    }
    NSInteger i = 0;
    Solution *s0 = solutions[0];
    for (Solution *solution in solutions) {
        NSLog(@"---%ld:-Solution:%@",++i,solution);
        if (solution.count < s0.count || \
            (solution.value > s0.value && solution.count == s0.count)) {
                s0 = solution;
            }
        }
    
    return s0;
}

//对牌进行组合，组牌，组成连牌
- (Solution *)combSolutionWithcards:(NSArray<Card *> *)cards andDarwHandCards:(NSArray<HandCard *> *) handCards
{
    NSMutableString *strM  = [NSMutableString string];
    for (NSInteger i = 0 ; i< cards.count; i++) {
        [strM appendFormat:@"%@",cards[i]];
    }
    NSLog(@"combCards:\n%@",strM);
    
    Solution *solution = [[Solution alloc] init];

    //非空的情况下
    if (handCards !=nil ) {
        //首先把提取出的牌添加进方案组
        //尝试对方案组里面的牌进行组合，有连对情况，飞机情况
        for (NSInteger i = 0 ; i < handCards.count; i++) {
            //炸弹
            if (handCards[i].cardType == BOMB) {
                [solution.bombs addObject:handCards[i]];
            }else if(handCards[i].cardType == THREE) {
                [solution.threes addObject:handCards[i]];
            }else if(handCards[i].cardType == DOUBLE) {
                [solution.doubles addObject:handCards[i]];
            }
        }
    }
    
    [solution sortSolution];
    //对提取的牌中的三条去组飞机
    //三条数目大于2,尝试去组飞机
    if (solution.threes.count >= 2) {
        NSInteger pos = 0;
        NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
        while (pos < solution.threes.count - 1) {
            NSInteger i = pos;
            NSInteger j = 0;
            NSInteger value = 0;
            //找到一对飞机了
            if (solution.threes[i].value - solution.threes[i+1].value == 1) {
                [set addIndex:i];
                [set addIndex:i+1];
                HandCard *handCard = [[HandCard alloc] init];
                
                [handCard addHandCard:solution.threes[i]];
                [handCard addHandCard:solution.threes[i+1]];
                
                [solution.flys addObject:handCard];
                value = solution.threes[i+1].value;
                pos++;
                //尝试去连接更长的飞机
                for (j =i + 1 ; j < solution.threes.count ; j++) {
                    if (solution.threes[j].value != --value) {
                        break;
                    }else {
                        [set addIndex:j];
                        [handCard addHandCard:solution.threes[j]];
                    }
                }
                //找到了,结束了
                if(j > i + 1) {
                    pos = j-1;
                }
            }
            pos++;
        }
        //删除三条的数据
        if ([set count]) {
            [solution.threes removeObjectsAtIndexes:set];
        }
    }
    //这个是对提取的牌中的对子进行组连对
    //对子数目多，尝试去组连对
    if (solution.doubles.count >= 3) {
        NSInteger pos = 0;
        NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
        while (pos < solution.doubles.count - 2) {
            NSInteger i = pos;
            NSInteger j = 0;
            NSInteger value = 0;
            //找到连对了
            if (solution.doubles[i].value - solution.doubles[i+1].value == 1 && \
                solution.doubles[i+1].value - solution.doubles[i+2].value == 1) {
                [set addIndex:i];
                [set addIndex:i+1];
                [set addIndex:i+2];
                HandCard *handCard = [[HandCard alloc] init];
                [handCard addHandCard:solution.doubles[i]];
                [handCard addHandCard:solution.doubles[i+1]];
                [handCard addHandCard:solution.doubles[i+2]];
    
                [solution.serialDoubles addObject:handCard];
                
                value = solution.doubles[i+2].value;
                pos+=2;
                //尝试去连接更长的对子
                for (j =i + 1 ; j < solution.doubles.count ; j++) {
                    if (solution.doubles[j].value != --value) {
                        break;
                    }else {
                        [set addIndex:j];
                        [handCard addHandCard:solution.doubles[j]];
                    }
                }
                //找到了,结束了
                if(j > i + 1) {
                    pos = j-1;
                }
            }
            pos++;
        }
        //删除对子的数据
        if ([set count]) {
            [solution.doubles removeObjectsAtIndexes:set];
        }
    }

    NSInteger minValue;
    NSInteger maxValue;
//    NSInteger pos;
    NSMutableArray<Card *> *tempCards = [NSMutableArray arrayWithArray:cards];
    
    /*
#warning COMB
    //先组连对，
    //先手对子的，
    //对子中间的，连子也要试着组
    if ([tempCards count] > 0) {
        minValue = tempCards[tempCards.count - 1].value;
        maxValue = tempCards[0].value;
        //先从最小开始组
        pos = minValue;
        //去组连对
        while (pos <= maxValue - 4) {
            
            NSInteger i = pos;
            NSInteger j = 0;
            for (i = pos; i < pos + 3; i++) {
                if ([self rangeOfCardWithValue:i andTarget:tempCards].length < 2) {
                    break;
                }
            }
            if (i == pos + 3) {
                HandCard *handCard = [[HandCard alloc] init];
                for (NSInteger value = i - 3 ; value < i; value ++) {
                    
                    //从tempCards里面拿出这一张牌，然后移出这一张牌
                    [handCard addCard:[self cardOfCardWithValue:value andTarget:tempCards]];
                    [tempCards removeObject:[self cardOfCardWithValue:value andTarget:cards]];
                    //再拿一张牌，再移一张
                    [handCard addCard:[self cardOfCardWithValue:value andTarget:tempCards]];
                    [tempCards removeObject:[self cardOfCardWithValue:value andTarget:cards]];
                }
                //尝试去组合更长的牌
                for (j = i; j <= maxValue ; j++) {
                    if ([self rangeOfCardWithValue:j andTarget:tempCards].length < 2) {
                        break;
                    }
                }
                if (j > i) {
                    for (NSInteger value = i ; value < j; value ++) {
                        //从tempCards里面拿出这一张牌，然后移出这一张牌
                        [handCard addCard:[self cardOfCardWithValue:value andTarget:tempCards]];
                        [tempCards removeObject:[self cardOfCardWithValue:value andTarget:cards]];
                        
                        //从tempCards里面拿出这一张牌，然后移出这一张牌
                        [handCard addCard:[self cardOfCardWithValue:value andTarget:tempCards]];
                        [tempCards removeObject:[self cardOfCardWithValue:value andTarget:cards]];
                    }
                }
                NSLog(@"comb serialDouble:%@",handCard);
                //[serialDoubles addObject:handCard];
                [solution.serialDoubles addObject:handCard];
                //直接定位下一张牌值
                pos = j-1;
            }
            pos++;
        }
    }
*/
    //组牌
    //组连子
    if ([tempCards count] > 0) {
        
        minValue = tempCards[tempCards.count - 1].value;
        maxValue = tempCards[0].value;
        //先从最小开始组
        NSInteger pos = minValue;
        //组顺子
        while (pos <= maxValue - 4) {
            NSInteger i = pos;
            NSInteger j = 0;
            
            if (tempCards.count < 5) {
                break;
            }
            //牌面最大值
            maxValue = tempCards[0].value;
            
            for (i = pos; i < pos + 5; i++) {
                if ([self rangeOfCardWithValue:i andTarget:tempCards].length < 1) {
                    break;
                }
            }
            //有五个连续的
            if (i == pos + 5) {
                
                HandCard *handCard = [[HandCard alloc] init];
                for (NSInteger value = i - 5 ; value < i; value ++) {
                    //从tempCards里面拿出这一张牌，然后移出这一张牌
                    [handCard addCard:[self cardOfCardWithValue:value andTarget:tempCards]];
                    [tempCards removeObject:[self cardOfCardWithValue:value andTarget:cards]];
                }
                //尝试去组合更长的牌
                for (j = i; j <= maxValue ; j++) {
                    NSRange range = [self rangeOfCardWithValue:j andTarget:tempCards];
                    //在长度满足的情况两条或是以上K,A，就不要组顺子了
                    if (range.length < 1 || (range.length >= 2 && j >= 13 )) {
                        break;
                    }
                }
                if (j > i) {
                    for (NSInteger value = i ; value < j; value ++) {
                        //从tempCards里面拿出这一张牌，然后移出这一张牌
                        [handCard addCard:[self cardOfCardWithValue:value andTarget:tempCards]];
                        [tempCards removeObject:[self cardOfCardWithValue:value andTarget:cards]];
                    }
                }
                NSLog(@"comb serialSingle:%@",handCard);
                [solution.serialSingles addObject:handCard];
                //继续尝试别的牌，直到组不成顺子
            }
            pos++;
        }
    }

    //再把余下的一些牌加进方案里面去，有对子,个子,三条,炸弹
    for (NSInteger i = 0 ; i < tempCards.count; i++) {
        NSRange range = [self rangeOfCardWithValue:tempCards[i].value andTarget:tempCards];
        if (range.length == 1) {
            HandCard * handCard = [[HandCard alloc] init];
            [handCard addCard:tempCards[i]];
            [solution.singles addObject:handCard];
        }else if(range.length == 2) {
            HandCard *handCard = [[HandCard alloc] init];
            [handCard addCard:tempCards[i]];
            [handCard addCard:tempCards[i+1]];
            [solution.doubles addObject:handCard];
            i++;
        }else if(range.length == 3) {
            HandCard *handCard = [[HandCard alloc] init];
            [handCard addCard:tempCards[i]];
            [handCard addCard:tempCards[i+1]];
            [handCard addCard:tempCards[i+2]];
            [solution.threes addObject:handCard];
            i = i+2;
            
        }else if(range.length == 4) {
            HandCard *handCard = [[HandCard alloc] init];
            [handCard addCard:tempCards[i]];
            [handCard addCard:tempCards[i+1]];
            [handCard addCard:tempCards[i+2]];
            [handCard addCard:tempCards[i+3]];
            
            [solution.bombs addObject:handCard];
            i = i+3;
        }
    }
    //重置flag
    [solution reSetflag];
    return solution;
}





#pragma mark combination
//排列组合计算
#define MAX_COMB_COUNT 26
NSInteger gcomb[MAX_COMB_COUNT]={0};

- (NSMutableArray<NSMutableArray *> *)combArr
{
    if(!_combArr)
    {
        _combArr = [NSMutableArray array];
    }
    return _combArr;
}

- (void)combination:(NSInteger) m :(NSInteger) n
{
    for (NSInteger i = m ; i>=n ; i--) {
        gcomb[n] = i;
        if (n > 1) {
            [self combination:i-1 :n-1];
        }else{
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger j = gcomb[0]; j > 0; j--) {
                [arr addObject:[NSNumber numberWithInteger:gcomb[j]]];
            }
            [self.combArr addObject:arr];
        }
    }
}

//取一个到取全部的所有组合
- (void)combinationAllWithNumber:(NSInteger) number
{
    NSLog(@"comb:%ld",number);
    
    [self.combArr removeAllObjects];
    
    for (NSInteger i = 1; i <= number; i++) {
        gcomb[0] = i;
        [self combination:number :i];
    }
}

- (NSString *)description
{
    NSMutableString *str = [NSMutableString string];

    for (NSArray *arr in self.combArr) {
        for (NSNumber *n in arr) {
            [str appendFormat:@"%ld ",n.integerValue];
        }
        [str appendFormat:@"\n"];
    }
    
    return [NSString stringWithFormat:@"%@",str];
}










@end
