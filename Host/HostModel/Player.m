//
//  Player.m
//  HostModel
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "Player.h"
#import "Recorder.h"


@implementation Player
//地主编号
static NSInteger ghostID = 0;

- (instancetype)initWithID:(NSInteger)nID
{
    self = [super init];
    if (self) {
        _nID = nID;
        _cards = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isHost
{
    if(self.nID == ghostID)
        return TRUE;
    
    return FALSE;
}

+ (void)setHostID:(NSInteger)nID
{
    ghostID = nID;
}

+ (NSInteger)hostID
{
    return ghostID;
}

//拿牌
- (void)getCard:(Card *)card
{
    [self.cards addObject:card];
}

- (NSString *)description
{
    NSMutableString *strCard = [[NSMutableString alloc] init];
    
    NSString *str=@"";
    if([self isHost])
        str = @"Host";
    
    for (id obj in self.cards) {
        [strCard appendFormat:@"%@ ",obj];
    }
    return [NSString stringWithFormat:@"\nID:%ld %@\n%@", _nID,str,strCard];
}

//排序牌,逆序排
- (void)sortCards
{
    [_cards sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Card *card1 = obj1;
        Card *card2 = obj2;
        
        return [card2 compare:card1];
    }];
}

//判断打上一手牌的人是敌方还是我方
- (NSInteger)judgeLastPlayerIsFriend
{
    Controller *controller = [Controller DefaultController];
    NSInteger nid = controller.handCarder;

    //如果那手牌的主人是地主,并且不是自己，返回敌方
    if ([controller.players[nid] isHost] && ([controller.players[nid] nID] != self.nID) ) {
        return ENEMY;
    }
    else
        return FRIEND;
}

//出牌
- (void)sendCardWithHandCard:(HandCard *)handCard
{
    Recorder *recorder = [Recorder DefaultRecorder];
    
    //记录一下牌
    for (Card *card in handCard.cards) {
        [recorder recorderCard:card];
    }
    
    //桌面记录一下情况
    Controller *controller = [Controller DefaultController];
    controller.handCarder = self.nID;
    controller.handCard = handCard;

    //移除
    [self.cards removeObjectsInArray:handCard.cards];
    
    //没有牌了
    if([self.cards count] == 0) {
        controller.gameOver = YES;
    }
    //只有一张牌了，报警
    else if([self.cards count] == 1) {
        [recorder warnWithPlayer:self];
    }
    
    //回应
    self.response = SEND;
}

//不出
- (void)pass
{
    self.response = PASS;
}

- (void)callHost
{
    [Player setHostID:self.nID];
}

//出牌过程
- (void)sendCard
{
    //0是下边玩家,也就是自已
    if (self.nID - 1 != 0) {
        HandCard *handCard;
        BOOL bret = [self.thinker thinkPlayWithCards:self.cards resultHandCard:&handCard];
        if (!bret) {
            [self pass];
            return ;
        }
        else{
            [self sendCardWithHandCard:handCard];
            return ;
        }
        
        //self.response = NORESPOND;
    }
}

- (void)noCallHost
{
    
}

@end
