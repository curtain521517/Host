//
//  HandCard.m
//  HostModel
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "HandCard.h"

@implementation HandCard

- (id)initWithCards:(NSArray<Card *> *)cards
{
    self = [super init];
    if (self) {
        _bAnalyse = NO;
        _cards = [NSMutableArray arrayWithArray:cards];
    }
    return self;
}

- (NSMutableArray<Card *>*)cards
{
    if(!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (NSInteger)length
{
    if (!_bAnalyse) {
        [self sortHandCard];
        Analyser *analyse = [[Analyser alloc] init];
        [analyse analyseTarget:self];
        return _length;
    }
    return _length;
}

- (NSInteger)value
{
    if (!_bAnalyse) {
        [self sortHandCard];
        Analyser *analyse = [[Analyser alloc] init];
        [analyse analyseTarget:self];
        
        return _value;
    }
    return _value;
}

- (CardType)cardType
{
    if (!_bAnalyse) {
        [self sortHandCard];
        Analyser *analyse = [[Analyser alloc] init];
        [analyse analyseTarget:self];
        
        return _cardType;
    }
    return _cardType;
}

- (void)addCard:(Card *)card
{
    _bAnalyse = NO;
    [self.cards addObject:card];
}

- (void)addHandCard:(HandCard *)handCard
{
    for (Card *card in handCard.cards) {
        [self addCard:card];
    }
}

//逆序排的
- (void)sortHandCard
{
    [_cards sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Card *card1 = obj1;
        Card *card2 = obj2;
        
        return [card2 compare:card1];
    }];
}

//两手牌比较
- (NSInteger)compare:(HandCard *)object
{
    if(self.cardType == ERRORTYPE || object.cardType == ERRORTYPE)
        return 0;
    
    if(self.cardType == object.cardType && self.length == object.length) {
            return self.value - object.value;
    }
    
    //谁有炸弹谁大,都是炸弹比大小
    if(self.cardType == BOMB && object.cardType != BOMB) {
        return 1;
    }
    else if(self.cardType != BOMB && object.cardType == BOMB) {
        return -1;
    }
    else if(self.cardType == BOMB && object.cardType == BOMB) {
        return self.value - object.value;
    }
    
    return 0;//无法比较或是相同
}

- (NSString *)description
{
    NSArray *cardType = @[@"0",@"单张",@"对子",@"三张",@"连子",@"连对",@"飞机", \
                          @"炸弹",@"三带一",@"三带二",@"飞机带一张牌",@"飞机带两张牌",@"四带2单张",@"四带2对",@"错误牌型"];

    NSMutableString *str = [NSMutableString string];
    for (id obj in self.cards) {
        [str appendFormat:@"%@ ",obj];
    }
    
    return [NSString stringWithFormat:@"\n%@  { cardType:%@, Value:%ld }",str, cardType[self.cardType],self.value];
}

@end
