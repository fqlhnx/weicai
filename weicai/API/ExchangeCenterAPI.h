//
//  ExchangeCenterAPI.h
//  weicai
//
//  Created by liuhongnian on 14-10-9.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "BaseRequest.h"

typedef  NS_ENUM(NSUInteger, exchangeType){
    aliPay = 1,
    phoneNumber = 2
};

@interface ExchangeCenterAPI : BaseRequest

//支付宝提现申请
//http://121.40.193.213/Integral/public/index.php/api/exchange?username=admin&target=1&integral=100&ip=61.160.202.235&amount=100



//手机话费充值申请
//http://121.40.193.213/Integral/public/index.php/api/exchange?username=admin&target=2&integral=100&ip=61.160.202.235&amount=100

//兑换申请
- (void)applicationForConversionWithUserName:(NSString*)uName
                                      target:(exchangeType)type
                                      fromIP:(NSString*)ipaddr
                                    integral:(NSInteger)number
                                      amount:(NSUInteger)amount
                              prepaidAccount:(NSString*)preAccount
                                     success:(void(^)())success
                                     failure:(void(^)(NSError *error))failure ;

//http://www.integral.com/index.php/api/getExchangeList?state=tangwei
- (void)getTheLatestExchangeRecords:(void (^)(NSArray *records))success
                            failure:(void(^)(NSError *error))failure;

@end
