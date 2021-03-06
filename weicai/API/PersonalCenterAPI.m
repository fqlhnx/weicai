//
//  PersonalCenterAPI.m
//  weicai
//
//  Created by liuhongnian on 14-10-8.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "PersonalCenterAPI.h"
#import "RMMapper.h"
#import "TaskInfo.h"
#import "Exchange.h"

#import "SVProgressHUD.h"

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

- (void)queryExchangeDetailWithUserID:(NSString *)uID
                                 page:(NSString *)page
                              success:(void (^)(NSArray *))success
                               failed:(void (^)(NSError *))failed
{
    NSDictionary *dic = @{@"page": page,
                          @"username":uID};
    [super getRequestFromePath:kqueryIntegralDetailURL
                    parameters:dic success:^(id responseResult) {
                        
                        NSArray *response = responseResult[@"message"];
                        NSMutableArray *results = [NSMutableArray array];
                        
                        for (NSDictionary *obj in response) {
                            Exchange *exchangeObj = [RMMapper objectWithClass:[Exchange class] fromDictionary:obj];
                            [results addObject:exchangeObj];
                        }
                        success(results);
                        
                    } failure:^(NSError *error, id errorResponse) {
                        
                        failed(error);
                    }];
}

- (void)integralDetail:(NSString *)userID
                  page:(NSString *)page
               success:(void (^)(NSArray *))success
                failed:(void (^)(NSError *))failed
{

    NSDictionary *dic = @{@"page": page,
                          @"username":userID};
    [super getRequestFromePath:kintegralDetailURL
                    parameters:dic
                       success:^(id responseResult) {
            
                           NSArray *results = responseResult[@"message"];
                           if ([results isKindOfClass:[NSArray class]]) {
                               
                               NSMutableArray *arr = [NSMutableArray array];
                               for (NSDictionary *taskDic in results) {
                                   TaskInfo *taskObj = [RMMapper objectWithClass:[TaskInfo class] fromDictionary:taskDic];
                                   [arr addObject:taskObj];
                                   
                               }
                               success(arr);
                           }
                           
                       } failure:^(NSError *error, id errorResponse) {
                           failed(error);
                       }];
    
}

- (void)getNewsDescriptionSuccess:(void (^)(NSString *))success
                           failed:(void (^)(NSError *))failed
{
//    {
//        "message": {
//            "id": "3",
//            "description": "123123456456111"
//        }
//    }

    [super getRequestFromePath:kgetDescriptionURL
                    parameters:nil
                       success:^(id responseResult)
    {
        NSDictionary *responseDic = responseResult[@"message"];
        if (responseDic[@"description"]) {
            NSString *content = responseDic[@"description"];
            success(content);
        }
    }
     
    
                       failure:^(NSError *error, id errorResponse)
    
    {
        failed(error);
    }];
}

- (void)getUserID:(NSString *)uuid
           fromIP:(NSString *)ipAddress
        competion:(void (^)(NSString *, NSError *))competionBlock
{
    [super getRequestFromePath:kgetUserIDURL
                    parameters:@{@"username": uuid,
                                 @"ip":ipAddress,
                                 @"gzsname":[NSNull null]}
                       success:^(id responseResult)
    {
        //获取用户id成功
        if ([responseResult[@"message"] isEqualToString:@"success"])
        {
            NSString *userID = responseResult[@"UserId"];
            competionBlock (userID,nil);

        }
        else
        {
            //获取用户id失败
            competionBlock(nil,[NSError errorWithDomain:@"获取用户ID失败" code:8 userInfo:nil]);
            
        }

    } failure:^(NSError *error, id errorResponse) {
        
        competionBlock (nil,error);
    }];
}

@end
