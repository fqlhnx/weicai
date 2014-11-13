//
//  IPAddressListRequest.m
//  weicai
//
//  Created by liuhongnian on 14-10-15.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "IPAddressListRequest.h"
#import "IPInfo.h"
#import "RMMapper.h"

NSString *const kIpAddressListURL = @"http://121.40.193.213/Integral/public/index.php/api/getLimitIp";

@implementation IPAddressListRequest

- (void)getIPAddressOfTheLimitSuccess:(void (^)(NSArray *))success
                               Failed:(void (^)(NSError *))failed
{
    [super getRequestFromePath:kIpAddressListURL
                    parameters:nil
                       success:^(id responseResult)
    {
        NSMutableArray *ips = [NSMutableArray arrayWithCapacity:5];
        
        if ([responseResult isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dic in responseResult)
            {
                IPInfo *ipInfo = [RMMapper objectWithClass:[IPInfo class] fromDictionary:dic];
                [ips addObject:ipInfo.ip];
            }
            success(ips);
        }
    }
                       failure:^(NSError *error, id errorResponse)
    {
  
        
    }];
}

@end

