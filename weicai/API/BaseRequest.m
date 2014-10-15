//
//  BaseRequest.m
//  weicai
//
//  Created by liuhongnian on 14-10-8.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "BaseRequest.h"

@interface BaseRequest ()

@end

@implementation BaseRequest

- (void)getRequestFromePath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(id))success
                    failure:(void (^)(NSError *, id))failure
{
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型

    [self GET:path
   parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
          success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error, operation.responseObject);
    }];
}

- (void)postRequestToPath:(NSString *)path
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *, id))failure
{
    [self POST:path
    parameters:parameters
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error,operation.responseObject);
    }];
}


@end
