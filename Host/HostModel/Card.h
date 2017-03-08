//
//  Card.h
//  HostModel
//
//  Created by mac on 16/5/10.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SMALLKING   16    //小王
#define BIGKING     17    //大王

#define BLACKPEACH  0     //黑桃
#define REDHEART    1     //红心
#define BLACKPLUM   2     //梅花
#define REDDIAMOND  3     //红方
#define KING        4     //王

@interface Card : NSObject

@property(nonatomic, assign)NSInteger rank;

@property(nonatomic, assign, readonly)NSInteger color;
@property(nonatomic, assign, readonly)NSInteger value;


- (BOOL)setCardWithValue:(NSInteger)value andColor:(NSInteger)color;


- (instancetype)initWithRank:(NSInteger)rank;
- (instancetype)initCardWithValue:(NSInteger)value andColor:(NSInteger)color;
+ (instancetype)cardWithValue:(NSInteger)value andColor:(NSInteger)color;

- (NSComparisonResult)compare:(Card *)object;


@end
