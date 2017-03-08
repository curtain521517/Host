//
//  Controller.h
//  HostModel
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Deck.h"
#import "HandCard.h"

@class Player;

@interface Controller : NSObject

@property(nonatomic, strong)Deck * deck;                    //这一整幅牌
@property(nonatomic, strong)NSArray<Player *> * players;    //玩家
@property(nonatomic, assign)NSInteger playingID;            //正在出牌的玩家ID

@property(nonatomic, strong)HandCard *handCard;             //桌面上打出的那手牌，主要用于比较
@property(nonatomic, assign)NSInteger handCarder;           //桌面上那手牌是谁打的，玩家编号

@property(nonatomic, getter=isGameOver)BOOL gameOver;       //游戏结束标志


+ (id)DefaultController;

- (void)sendCards;//发牌
- (void)nextPlayer;

@end
