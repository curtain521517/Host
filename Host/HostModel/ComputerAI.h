//
//  ComputerAI.h
//  Host
//
//  Created by mac on 16/5/29.
//  Copyright © 2016年 xufan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThinkPlayCardPro.h"
#import "JudgeCardsPro.h"

#import "Spliter.h"
#import "Recorder.h"
#import "Evaluater.h"

@interface ComputerAI : NSObject <ThinkPlayCardPro, JudgeCardsPro>

@property(nonatomic, strong)Spliter *spliter;
@property(nonatomic, strong)Evaluater *evaluater;

@end
