//
//  Recorder.m
//  HostModel
//
//  Created by mac on 16/5/13.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import "Recorder.h"

@implementation Recorder

+ (id)DefaultRecorder
{
    static id recorder = nil;
    if (recorder == nil) {
        recorder = [[Recorder alloc] init];
        [recorder initWarnPlayerID];
    }
    return recorder;
}

- (void)initWarnPlayerID
{
    _warnPlayerIDs[0] = 0;
    _warnPlayerIDs[1] = 0;
}

- (void)warnWithPlayer:(Player *) player
{
    if(_warnPlayerIDs[0]==0) {
        _warnPlayerIDs[0] = player.nID;
    }else if (_warnPlayerIDs[1]==0) {
        _warnPlayerIDs[1] = player.nID;
    }
}

- (void)recorderCard:(Card *)card
{
    if(card.value == BIGKING)
        self.countOfCardBigKing++;
    else if(card.value == SMALLKING)
        self.countOfCardSmallKing++;
    else if(card.value == SMALLKING - 1)
        self.countOfCard2++;
    else if(card.value == SMALLKING - 2)
        self.countOfCardA++;
}

@end
