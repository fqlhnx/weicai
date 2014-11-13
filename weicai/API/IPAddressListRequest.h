//
//  IPAddressListRequest.h
//  weicai
//
//  Created by liuhongnian on 14-10-15.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "BaseRequest.h"

@interface IPAddressListRequest : BaseRequest

//获取限制的IP地址
- (void)getIPAddressOfTheLimitSuccess:(void(^)(NSArray *ipList))success
                               Failed:(void(^)(NSError *error))failed;

@end
