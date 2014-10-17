//
//  TaskCenterAPI.h
//  weicai
//
//  Created by liuhongnian on 14-10-8.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "BaseRequest.h"

@interface TaskCenterAPI : BaseRequest


//获取用户所有积分
- (void)getIntegral:(NSString*)userID
            success:(void (^)(NSString *totalIntegral))success
            failure:(void (^)(NSError *error))failure;

//所有渠道列表
- (void)getAllChannels:(void (^)(NSArray *channels))success failure:(void (^)(NSError*error))failure;

- (void)getScrollContent:(void(^)(NSArray *contentsArr,NSError *error))competion;

@end
