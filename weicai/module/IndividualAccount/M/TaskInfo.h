//
//  TaskInfo.h
//  weicai
//
//  Created by liuhongnian on 14-10-17.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    "id": "604",
//    "telmember_id": "U00000300",
//    "channel_id": "0",
//    "created": "1413479203",
//    "is_deleted": "0",
//    "order_id": "890576D4D8F275D8E14EF8D7F435CB76",
//    "pubid": "faf77b3218329870f47ffca409085714",
//    "ad": "\u6084\u6084",
//    "adid": "c29aa4d2bf2e21ee1c5a62c6dc068e71",
//    "device": "3ef002f7-9f42-4102-a85c-f061edcc3483",
//    "price": "1.26",
//    "point": "126",
//    "identify": "5",
//    "storagetime": "1413479206"
//}

//ad = "\U9014\U725b\U65c5\U6e38";
//adid = 1004027;
//"channel_id" = 0;
//created = 1414754532;
//device = "3EF002F7-9F42-4102-A85C-F061EDCC3483";
//id = 1696;
//identify = 1;
//"is_deleted" = 0;
//"order_id" = 175010747;
//point = 140;
//price = "1.40";
//pubid = "96ZJ2c6AzeE/rwTBKU";
//storagetime = 1414754553;
//"telmember_id" = U00000869;

@interface TaskInfo : NSObject

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *telmember_id;
@property (nonatomic,copy)NSString *channel_id;
@property (nonatomic,copy)NSString *created;
@property (nonatomic,copy)NSString *is_deleted;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *pubid;
@property (nonatomic,copy)NSString *ad;
@property (nonatomic,copy)NSString *adid;
@property (nonatomic,copy)NSString *device;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *point;
@property (nonatomic,copy)NSString *identify;
@property (nonatomic,copy)NSString *storagetime;

+ (NSString*)channelNameByID:(NSString*)channelID;

@end
