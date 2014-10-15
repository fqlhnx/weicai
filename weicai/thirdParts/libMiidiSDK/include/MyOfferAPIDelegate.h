

#import <UIKit/UIKit.h>
@class MyOfferAPI;


@protocol MyOfferAPIDelegate <NSObject>
@optional



#pragma mark - 积分墙, 推荐墙 展示接口调用后的回掉方法
// 请求应用列表成功
// 
// 详解:
//      广告墙请求成功后回调该方法
// 补充:
//
- (void)didReceiveOffers;

// 请求应用列表失败
// 
// 详解:
//      广告墙请求失败后回调该方法
// 补充:
//
- (void)didFailToReceiveOffers:(NSError *)error;

#pragma mark Screen View Notification Methods

// 显示全屏页面
// 
// 详解:
//      全屏页面显示完成后回调该方法
// 补充:
//
- (void)didShowWallView;

// 隐藏全屏页面
// 
// 详解:
//      全屏页面隐藏完成后回调该方法
// 补充:
//
- (void)didDismissWallView;


#pragma mark - API对接接口 调用 相关的回掉方法
// 请求积分值成功后调用
//
// 详解:当接收服务器返回的积分值成功后调用该函数
// 补充：totalPoints: 返回用户的总积分
//      pointName  : 返回的积分名称
- (void)didReceiveGetPoints:(NSInteger)totalPoints forPointName:(NSString*)pointName;

// 请求积分值数据失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didFailReceiveGetPoints:(NSError *)error;

#pragma mark - UI DIY
- (void)myOfferViewWillAppear:(UIViewController *)viewController;
- (void)myOfferViewDidAppear:(UIViewController *)viewController;

@end
