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
- (void)getTodayIntegral:(void(^)(NSNumber *todayIntegral,NSError *error))competion;

//收益明细
- (void)integralDetail:(NSString*)userID
                  page:(NSString*)page
               success:(void(^)(NSArray* results))success failed:(void (^)(NSError* error))failed;
//兑换详情
- (void)queryExchangeDetailWithUserID:(NSString*)uID page:(NSString*)page success:(void(^)(NSArray *results))success failed:(void(^)(NSError *error))failed;
//获取最新的消息
- (void)getNewsDescriptionSuccess:(void(^)(NSString*desString))success
                           failed:(void(^)(NSError *error))failed;

//获取用户ID
- (void)getUserID:(NSString*)uuid
           fromIP:(NSString*)ipAddress
        competion:(void(^)(NSString *uID,NSError *error))competionBlock;

@end
