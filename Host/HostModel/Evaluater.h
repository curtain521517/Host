//
//  Evaluater.h
//  HostModel
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 xufan. All rights reserved.




#import <Foundation/Foundation.h>
#import "Card.h"

@interface Evaluater : NSObject

@property(nonatomic, strong)NSArray<Card *> * cards;

//
@property(nonatomic, assign, readonly)float value;

- (id)initWithCards:(NSArray<Card *> *)cards;


@end
