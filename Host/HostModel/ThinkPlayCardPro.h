//
//  ThinkPlayCardPro.h
//  Host
//
//  Created by mac on 16/5/29.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;
@class HandCard;

@protocol ThinkPlayCardPro <NSObject>

- (BOOL)thinkPlayWithCards:(NSArray<Card *> *)cards resultHandCard:(HandCard **)result;

@end
