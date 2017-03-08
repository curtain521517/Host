//
//  Evaluater.m
//  HostModel
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "Evaluater.h"
#import "Spliter.h"
@implementation Evaluater

@synthesize value = _value;

- (id)initWithCards:(NSArray<Card *> *)cards
{
    self = [super init];
    if (self) {
        self.cards = [NSArray arrayWithArray:cards];
    }
    
    return self;
}

- (float)value
{
    [self judge];
    return _value;
}


//  一整手牌的价值评估，主要用于叫地主判断
// 大王(3.5)，小王(3)，2(2.5)，A(2),k(1.5),Q(1),J(0.5),其它小牌不加分
// 花牌花牌每多一张+0.5，如2点，22(5.5),222(7.5+1 = 8.5)
//
//
//

- (void)judge
{
    if (self.cards.count==0)
        return;
    
    _value = 0;
    self.cards = [self.cards sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(Card *)obj2 compare:(Card*)obj1];
    }];
    
    //大王
    NSRange range = [Spliter rangeOfCardWithValue:BIGKING andTarget:self.cards];
    if (range.location != NSNotFound) {
        _value +=3.5;
    }
    //小王
    range = [Spliter rangeOfCardWithValue:SMALLKING andTarget:self.cards];
    if (range.location != NSNotFound) {
        _value +=3;
    }
    //2点
    range = [Spliter rangeOfCardWithValue:15 andTarget:self.cards];
    if (range.location != NSNotFound) {
        _value +=(range.length*2.5 +(range.length-1)*0.5);
    }
    //A
    range = [Spliter rangeOfCardWithValue:14 andTarget:self.cards];
    if (range.location != NSNotFound) {
        _value +=(range.length*2 +(range.length-1)*0.5);
    }
    //K
    range = [Spliter rangeOfCardWithValue:13 andTarget:self.cards];
    if (range.location != NSNotFound) {
        _value +=(range.length*1.5 +(range.length-1)*0.5);
    }
    //Q
    range = [Spliter rangeOfCardWithValue:12 andTarget:self.cards];
    if (range.location != NSNotFound) {
        _value +=(range.length*1.0 +(range.length-1)*0.3);
    }
    //J
    range = [Spliter rangeOfCardWithValue:11 andTarget:self.cards];
    if (range.location != NSNotFound) {
        _value +=(range.length*0.5 +(range.length-1)*0.2);
    }
}












@end
