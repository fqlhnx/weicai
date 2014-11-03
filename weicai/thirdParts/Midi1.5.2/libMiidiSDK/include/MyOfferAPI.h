

#import <UIKit/UIKit.h>
#import "MyOfferAPIDelegate.h"



@interface MyOfferAPI : NSObject


#pragma mark - 配置SDK接口<开发者必调接口>
//
// 设置发布应用的应用id, 应用密码信息,必须在应用启动的时候呼叫
// 参数 appID		:开发者应用ID ;     开发者到 www.miidi.net 上提交应用时候,获取id和密码
// 参数 appPassword	:开发者的安全密钥 ;  开发者到 www.miidi.net 上提交应用时候,获取id和密码
//
+(void) setAppPublisher:(NSString*) appID withAppSecret:(NSString*)appSecret;

#pragma mark - 资源展示接口
// 显示积分墙
#pragma mark -
+ (BOOL) showAppOffers:(UIViewController*)hostViewController withDelegate:(id<MyOfferAPIDelegate>) delegate;

// 显示无积分推荐墙
// 参数 hostViewController		: 通过api [hostViewController presentModalViewController:nav animated:YES];
+ (BOOL) showAppOffersNoScore:(UIViewController*)hostViewController withDelegate:(id<MyOfferAPIDelegate>) delegate;


#pragma mark - 设置用户ID接口
// 用于服务器积分对接,设置自定义参数,参数可以传递给对接服务器
// 参数 paramText				: 需要传递给对接服务器的自定义参数  
+ (void) setUserParam:(NSString*)paramText;


#pragma mark - API对接接口
//积分查询, 增加用户积分, 扣除用户积分接口
+ (void)requestGetPoints:(id<MyOfferAPIDelegate>)delegate;


#pragma mark - 其他功能接口
// 获取Miidi广告IOS 版本号
+(NSString*) getSdkVersion;
@end
