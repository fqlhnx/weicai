//
//  BeeDeviceInfo.m
//  weicai
//
//  Created by liuhongnian on 14-10-9.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "BeeDeviceInfo.h"

@implementation BeeDeviceInfo

+ (void)connectedToTheInternetToGetIPAddress:(void (^)(NSString *, NSError *))result
{
    NSURL *url = [NSURL URLWithString:@"http://ip-api.com/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        
        if (!connectionError)
        {
            NSLog(@"获取IP成功");
            id resultDic = [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingMutableLeaves
                                              error:NULL];
            if([resultDic isKindOfClass:[NSDictionary class]])
            {
                NSString *ipAddress = resultDic[@"query"];
                result(ipAddress,nil);
            }
        }
        else
        {
            result(nil,connectionError);
        }
        
    }];
}

@end
