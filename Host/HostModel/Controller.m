//
//  Controller.m
//  HostModel
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "Controller.h"
#import "ComputerAI.h"
@implementation Controller


+ (id)DefaultController
{
    static id controller = nil;
    if (controller == nil) {
        controller = [[Controller alloc] init];
    }
    return controller;
}

- (NSArray<Player *> *)players
{
    if(!_players)
    {
        Player *player1 = [[Player alloc] initWithID:1];
        Player *player2 = [[Player alloc] initWithID:2];
        Player *player3 = [[Player alloc] initWithID:3];
        
        player2.thinker = [[ComputerAI alloc] init];
        player3.thinker = [[ComputerAI alloc] init];
        
        _players = [[NSArray alloc] initWithObjects:player1, player2, player3, nil];
    }
    
    return _players;
}

- (void)sendCards
{
    if (self.deck.cards.count == 54) {
        for(NSInteger i = 0 ; i < 51/3 ; i++) {
            [self.players[0] getCard:[self.deck sendCard]];
            [self.players[1] getCard:[self.deck sendCard]];
            [self.players[2] getCard:[self.deck sendCard]];
        }
    }
}

- (Deck *)deck
{
    if(!_deck)
    {
        _deck = [[Deck alloc] init];
    }
    return _deck;
}

- (BOOL)isGameOver
{
    return _gameOver;
}

- (void)nextPlayer
{
    //上一家恢复默认没有回应
    self.players[self.playingID - 1].response = NO;
    self.playingID = self.playingID % 3 + 1;
}




@end
