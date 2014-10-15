//
//  ExchangeCenterAPI.m
//  weicai
//
//  Created by liuhongnian on 14-10-9.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "ExchangeCenterAPI.h"

NSString *const kExchangeRequestURL = @"Integral/public/index.php/api/exchange";

@implementation ExchangeCenterAPI

- (void)applicationForConversionWithUserName:(NSString *)uName
                                      target:(exchangeType)type
                                      fromIP:(NSString *)ipaddr
                                    integral:(NSInteger)number
                                      amount:(NSUInteger)amount
{
    NSDictionary *dic = @{@"username": uName,
                          @"target":@(type),
                          @"integral":@(number),
                          @"amount":@(amount),
                          @"ip":ipaddr};
    
    [super getRequestFromePath:kExchangeRequestURL
                    parameters:dic
                       success:^(id responseResult) {
                           
        
    } failure:^(NSError *error, id errorResponse) {
        
    }];
}

@end
