//
//  Recorder.h
//  HostModel
//
//  Created by mac on 16/5/13.
//  Copyright © 2016年 xufan. All rights reserved.
//
//记牌器,single Class

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Player.h"

@interface Recorder : NSObject
{
    NSInteger _warnPlayerIDs[2];                                //记录已经报警的玩家ID号
}

@property(nonatomic, assign)NSInteger countOfCardA;             //A出牌数
@property(nonatomic, assign)NSInteger countOfCard2;             //2出牌数
@property(nonatomic, assign)NSInteger countOfCardSmallKing;     //小王出牌数
@property(nonatomic, assign)NSInteger countOfCardBigKing;       //大王出牌数

+ (id)DefaultRecorder;
- (void)recorderCard:(Card *)card;
- (void)warnWithPlayer:(Player *) player;

@end
