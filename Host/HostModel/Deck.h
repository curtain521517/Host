//
//  Deck.h
//  HostModel
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject
@property(nonatomic, strong)NSMutableArray<Card *> *cards;

- (void)shuffleCards;
- (Card *)sendCard;

@end
