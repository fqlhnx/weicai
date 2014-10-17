//
//  Exchange.h
//  weicai
//
//  Created by liuhongnian on 14-10-17.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exchange : NSObject

//amount = 1;
//created = 1413528385;
//"exchange_target" = 1;
//id = 31;
//integral = 1;
//ip = "58.216.49.66";
//"is_deleted" = 0;
//status = 5;
//"telmember_id" = 7;
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
