//
//  IPInfo.h
//  weicai
//
//  Created by liuhongnian on 14-11-13.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
//[
// {
//     "id": "86",
//     "ip": "114.226.195.48",
//     "created": "1415772799",
//     "endtime": null,
//     "status": "1",
//     "is_deleted": "0"
// },
// {
//     "id": "87",
//     "ip": "127.0.0.1",
//     "created": "1415882813",
//     "endtime": null,
//     "status": "1",
//     "is_deleted": "0"
// }
// ]
@interface IPInfo : NSObject

@property (nonatomic,copy)NSString *ip;
@property (nonatomic,copy)NSString *created;
@property (nonatomic,copy)NSString *endtime;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *is_deleted;

@end
