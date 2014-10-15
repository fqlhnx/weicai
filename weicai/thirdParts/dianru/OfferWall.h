//

//  版本2.4

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol OfferWallDelegate <NSObject>

@required

/*
 用于消费积分结果的回调
 */
-(void)didReceiveSpendScoreResult:(BOOL)isSuccess;

/*
 用于获取剩余积分结果的回调
 */
-(void)didReceiveGetScoreResult:(int)point;

@optional

/*
 应用程序唯一标识，从点入后台获取
 */
-(NSString *)applicationKey;
/*
 用户关闭点积分时的回调
 */


-(void)OfferWallClose;

/*
 标示用户的程序所支持的设备
 return @"iphone" 标识该App适用于iphone  如果App只适用于iphone必须要实现改方法.
 return @"ipad"   标识该App适用于ipad
 不实现该方法 或 return @"all" 标识该App是通用应用
 */
-(NSString *)OfferWallAppType;

/*
 提供用户的id数据..aa
 */
-(NSString *)OfferWallAppUserId;

///*
//    提供新的数量
// */
//-(void)getShowAdNumber:(int)number;

@end

@interface OfferWall : NSObject<NSURLConnectionDelegate>
{
    
}


+(void)initWithOfferWallDelegate:(id<OfferWallDelegate>)delegate;
+(void)getRemainPoint; //获得积分
+(void)spendPoint:(int)point; //消费积分
+(void)showOfferWall:(UIViewController*)viewController; //展示积分墙
+(void)OfferWallOnPause;
+(void)OfferWallResume;
//+(void)showAdNumber;

@end
