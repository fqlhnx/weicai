//
//  TaskCenterAPI.m
//  weicai
//
//  Created by liuhongnian on 14-10-8.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "TaskCenterAPI.h"

NSString *const kgetChannelsURLPath = @"Integral/public/index.php/api/getChannels";
NSString *const kUserIntegralURLPath = @"Integral/public/index.php/api/getUserIntegralSum";
NSString *const kgetScrollContentURL = @"Integral/public/index.php/api/getScrollContent";

@implementation TaskCenterAPI

- (void)getIntegral:(NSString *)userID
            success:(void (^)(NSString *))success
            failure:(void (^)(NSError *))failure
{
    NSDictionary *dic = @{@"member_id": userID};
    [super getRequestFromePath:kUserIntegralURLPath
                    parameters:dic success:^(id responseResult) {
                        success(responseResult[@"message"]);
        
    } failure:^(NSError *error, id errorResponse) {
        failure(error);
    }];
}

- (void)getAllChannels:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    [super getRequestFromePath:kgetChannelsURLPath
                    parameters:nil
                       success:^(id responseResult) {
                           
                           if ([responseResult isKindOfClass:[NSArray class]]) {
                               success(responseResult);
                           }else{
                               NSError *error = [NSError errorWithDomain:@"数据异常" code:90 userInfo:nil];
                               failure(error);
                           }
                               
    }
                       failure:^(NSError *error, id errorResponse) {
                           
                           failure(error);
        
    }];
}

- (void)getScrollContent:(void (^)(NSString *, NSError *))competion
{
//    [super getRequestFromePath:kgetScrollContentURL
//                    parameters:nil
//                       success:^(id responseResult) {
//                           competion()
//                       } failure:^(NSError *error, id errorResponse) {
//                           <#code#>
//                       }];
}

@end
