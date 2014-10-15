//
//  BaseRequest.h
//  weicai
//
//  Created by liuhongnian on 14-10-8.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface BaseRequest : AFHTTPRequestOperationManager

- (void)getRequestFromePath:(NSString*)path
                 parameters:(NSDictionary*)parameters
                    success:(void (^)(id responseResult)) success
                    failure:(void (^)(NSError *error,id errorResponse))failure;

- (void)postRequestToPath:(NSString*)path
               parameters:(NSDictionary*)parameters
                  success:(void (^)(id response))success
                  failure:(void(^)(NSError *error,id errorResponse))failure;

@end
