//
//  PersonalCenterAPI.h
//  weicai
//
//  Created by liuhongnian on 14-10-8.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "BaseRequest.h"

@interface PersonalCenterAPI : BaseRequest


//今日累计发放积分额
- (void)getTodayIntegral;

//收益明细
- (void)integralDetail:(NSString*)userID page:(NSString*)page;
//兑换详情
- (void)queryExchangeDetailWithUserID:(NSString*)uID page:(NSString*)page;

- (void)getNewsDescription;

//获取用户ID
- (void)getUserID:(NSString*)uuid competion:(void(^)(NSString *uID,NSError *error))competionBlock;

@end
