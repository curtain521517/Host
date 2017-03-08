//
//  Deck.m
//  HostModel
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "Deck.h"


@implementation Deck

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        for (NSInteger i = 0 ; i < 54; i++) {
            [self.cards addObject:[[Card alloc] initWithRank:i]];
        }
    }
    return self;
}

- (NSMutableArray *)cards
{
    if(!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (void)shuffleCards
{
    NSInteger count = 3;
    while (count--) {
        
        for (NSInteger i = 0; i < 54; i++) {
            NSInteger rand = arc4random() % (54-i) + i;
            [self.cards exchangeObjectAtIndex:i withObjectAtIndex:rand];
        }
    }
}

- (Card *)sendCard
{
    if([_cards count])
    {
        Card *card = [_cards objectAtIndex:[_cards count] - 1];
        [_cards removeObject:card];
    
        return card;
    }
    
    return nil;
}



@end
