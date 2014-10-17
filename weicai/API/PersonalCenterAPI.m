//
//  PersonalCenterAPI.m
//  weicai
//
//  Created by liuhongnian on 14-10-8.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "PersonalCenterAPI.h"

NSString *const kTodayIntegralURL = @"Integral/public/index.php/api/getTodayIntegral";
NSString *const kintegralDetailURL = @"Integral/public/index.php/api/getIntegralDetail";
NSString *const kqueryIntegralDetailURL = @"Integral/public/index.php/api/getExchange";
NSString *const kgetDescriptionURL = @"Integral/public/index.php/api/getDescription";
NSString *const kgetUserIDURL = @"Integral/public/index.php/api/storeUsername";

@implementation PersonalCenterAPI

- (void)getTodayIntegral:(void (^)(NSNumber *, NSError *))competion
{
    [super getRequestFromePath:kTodayIntegralURL
                    parameters:nil
                       success:^(id responseResult)
    {
        NSNumber *todayIntegral = responseResult[@"message"];
        competion(todayIntegral,nil);
    } failure:^(NSError *error, id errorResponse)
    {
        
    }];
}

- (void)queryExchangeDetailWithUserID:(NSString *)uID page:(NSString *)page
{
    NSDictionary *dic = @{@"page": page,
                          @"username":uID};
    [super getRequestFromePath:kqueryIntegralDetailURL
                    parameters:dic success:^(id responseResult) {
                        
                        //
                        
                    } failure:^(NSError *error, id errorResponse) {
                        
                    }];
}

- (void)integralDetail:(NSString *)userID page:(NSString *)page
{
//    ?page=1&username=tangwei
    NSDictionary *dic = @{@"page": page,
                          @"username":userID};
    [super getRequestFromePath:kintegralDetailURL
                    parameters:dic
                       success:^(id responseResult) {
                           
                           
                       } failure:^(NSError *error, id errorResponse) {
                           
                       }];
    
}

- (void)getNewsDescription
{
    [super getRequestFromePath:kgetDescriptionURL
                    parameters:nil
                       success:^(id responseResult)
    {
//        {
//            "message": {
//                "id": "3",
//                "description": "123123456456111"
//            }
//        }
        
    }
    
                       failure:^(NSError *error, id errorResponse)
    
    {
        
    }];
}

- (void)getUserID:(NSString *)uuid competion:(void (^)(NSString *, NSError *))competionBlock
{
    [super getRequestFromePath:kgetUserIDURL
                    parameters:@{@"username": uuid}
                       success:^(id responseResult)
    {
        NSString *userID = responseResult[@"UserId"];
        competionBlock (userID,nil);
    } failure:^(NSError *error, id errorResponse) {
        
        competionBlock (nil,error);
    }];
}

@end
