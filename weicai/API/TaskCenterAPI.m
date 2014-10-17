//
//  TaskCenterAPI.m
//  weicai
//
//  Created by liuhongnian on 14-10-8.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "TaskCenterAPI.h"
#import "RMMapper.h"
#import "ScrollContentInfo.h"

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
                        NSString *score = responseResult[@"message"];
                        if ([score isEqual:[NSNull null]]) {
                            success(@"0");
                        }else{
                            success(score);
                        }
        
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

- (void)getScrollContent:(void(^)(NSArray *contentsArr,NSError *error))competion
{
    [super getRequestFromePath:kgetScrollContentURL
                    parameters:nil
                       success:^(id responseResult) {
                        
                           NSMutableArray *strings = [NSMutableArray array];
                           for (NSDictionary *object in responseResult) {
                               ScrollContentInfo *content = [RMMapper objectWithClass:[ScrollContentInfo class] fromDictionary:object];
                               
                               [strings addObject:content.scroll_content];
                           }
                           competion(strings,nil);
                       } failure:^(NSError *error, id errorResponse) {
                           
                       }];
}

@end
