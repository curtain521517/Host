//
//  JudgeCardsPro.h
//  Host
//
//  Created by mac on 16/5/29.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;
@protocol JudgeCardsPro <NSObject>

- (NSInteger)judgeCards:(NSArray<Card*> *)cards;

@end
