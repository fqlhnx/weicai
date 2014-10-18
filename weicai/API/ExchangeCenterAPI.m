//
//  ExchangeCenterAPI.m
//  weicai
//
//  Created by liuhongnian on 14-10-9.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "ExchangeCenterAPI.h"
#import "ExchangeInfo.h"

#import "RMMapper.h"

NSString *const kExchangeRequestURL = @"Integral/public/index.php/api/exchange";
NSString *const kLastExchangeListURL = @"Integral/public/index.php/api/getExchangeList";

@implementation ExchangeCenterAPI

- (void)applicationForConversionWithUserName:(NSString *)uName
                                      target:(exchangeType)type
                                      fromIP:(NSString *)ipaddr
                                    integral:(NSInteger)number
                                      amount:(NSUInteger)amount
                              prepaidAccount:(NSString *)preAccount
                                     success:(void (^)())success
                                     failure:(void (^)(NSError *))failure
{
    NSDictionary *dic = @{@"username": uName,
                          @"target":@(type),
                          @"integral":@(number),
                          @"amount":@(amount),
                          @"ip":ipaddr,
                          @"account":preAccount};
    
    [super getRequestFromePath:kExchangeRequestURL
                    parameters:dic
                       success:^(id responseResult) {
                           
                           NSString *result = [responseResult objectForKey:@"message"];
                           if ([result isEqualToString:@"success"]) {
                               success();
                           }
    } failure:^(NSError *error, id errorResponse) {
        failure(error);
    }];
}

- (void)getTheLatestExchangeRecords:(void (^)(NSArray *))success
                            failure:(void (^)(NSError *))failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"tangwei",@"state", nil];
    [super getRequestFromePath:kLastExchangeListURL parameters:dic success:^(id responseResult) {
        
        NSArray *exchangeInfos = responseResult[@"message"];
        if ([exchangeInfos isKindOfClass:[NSArray class]])
        {
            NSMutableArray *results = [NSMutableArray array];
            for (NSDictionary *obj in exchangeInfos) {
                ExchangeInfo *info = [RMMapper objectWithClass:[ExchangeInfo class]
                                                        fromDictionary:obj];
                [results addObject:info];
            }
            success(results);
            
        }
    } failure:^(NSError *error, id errorResponse) {
        failure(error);
    }];
}

@end
