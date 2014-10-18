//
//  ExchangeInfo.h
//  weicai
//
//  Created by liuhongnian on 14-10-18.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
//amount = 2;
//created = 1413639245;
//"exchange_target" = 2;
//id = 35;
//integral = 1;
//ip = "180.115.238.252";
//"is_deleted" = 0;
//status = 5;
//"telmember_id" = U00000300;


@interface ExchangeInfo : NSObject

@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *created;
@property (nonatomic,copy)NSString *exchange_target;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *integral;
@property (nonatomic,copy)NSString *ip;
@property (nonatomic,copy)NSString *is_deleted;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *telmember_id;


@end
