//
//  Card.m
//  HostModel
//
//  Created by mac on 16/5/10.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "Card.h"
@implementation Card

- (instancetype)initWithRank:(NSInteger)rank
{
    self = [super init];
    if (self) {
        _rank = rank;
        
        if( rank <= 51 ) {
            _color = rank/13;
            _value = rank % 13 + 3;
        }else {
            _color = 4;
            _value = 15 + rank - 51;
        };
    }
    return self;
}

- (instancetype)initCardWithValue:(NSInteger)value andColor:(NSInteger)color
{
    self = [super init];
    if (self) {
        
        BOOL bret = [self setCardWithValue:value andColor:color];
        if(!bret)
            return nil;
    }
    return self;
}

- (BOOL)setCardWithValue:(NSInteger)value andColor:(NSInteger)color
{
    //错误过滤
    if(value < 0 || value > BIGKING)
        return FALSE;
    if (color < 0 || color > 4)
        return FALSE;
    
    _value = value;
    _color = color;
    
    if(value < SMALLKING)
    {
        _rank = (value - 3) + color * 13;
        
    }
    else{
        _rank = 52 + value - SMALLKING;
    }
    
    return TRUE;
}

+ (instancetype)cardWithValue:(NSInteger)value andColor:(NSInteger)color
{
    Card *card = [[Card alloc] initCardWithValue:value andColor:color];
    
    return card;
}

- (BOOL)isEqualTo:(Card *)object
{
    return self.rank == object.rank;
}

- (NSComparisonResult)compare:(Card *)card
{
    NSComparisonResult ret =  self.value - card.value;
    //花色小的要大
    if(ret == NSOrderedSame){
        return card.color - self.color;
    }
    return ret;    
}

- (NSString *)description
{
    NSArray *cardColor = @[@"♠️",@"♥️",@"♣️",@"♦️",@"👥"];
    NSArray *cardValue = @[@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K",@"A",@"2",@"小王",@"大王"];
    return [NSString stringWithFormat:@"%@%@",cardColor[self.color],cardValue[self.value-3]];
}


@end
