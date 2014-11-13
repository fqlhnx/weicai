//
//  AppDelegate.m
//  weicai
//
//  Created by liuhongnian on 14-9-28.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "AppDelegate.h"

#import "ExchangeCenterViewController.h"
#import "PersonalCenterViewController.h"
#import "TaskListViewController.h"
#import "BeeSystemInfo.h"
#import "BeeDeviceInfo.h"
#import "HelpViewController.h"
#import "IPAddressController.h"
#import "LB_DeviceInfo.h"
#import "GVUserDefaults+generalData.h"
#import "IPAddressListRequest.h"
#import "ServerConfig.h"

#import "UIDevice+IOKitDeviceInfo.h"
#import "OpenUDID.h"


@interface AppDelegate ()<UIAlertViewDelegate>

@property (nonatomic,strong)UITabBarController *tabBarCtrl;

@property (nonatomic,strong)UINavigationController *taskListRootNav;
@property (nonatomic,strong)TaskListViewController *taskListViewController;

@property (nonatomic,strong)PersonalCenterViewController *personalCenterVC;
@property (nonatomic,strong)UINavigationController *personalCenterRootNavCtrl;

@property (nonatomic,strong)ExchangeCenterViewController *exchangeVC;
@property (nonatomic,strong)UINavigationController *exchangeRootNavCtrl;

@property (nonatomic,strong)HelpViewController *helpVC;
@property (nonatomic,strong)UINavigationController *helpRootNavCtrl;

@property (nonatomic,strong)IPAddressListRequest *ipListRequest;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //ip 地址
    [IPAddressController sharedInstance];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(getedIPAddress:)
                                                name:DidGetCurrentIPAddress
                                              object:nil];
    //获取UDID或是设备序列号
    [self setupDeviceID];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self customUIAppearance];

    //task center
    self.taskListViewController = [[TaskListViewController alloc] initWithNibName:@"TaskListViewController"
                                                                           bundle:nil];
    self.taskListRootNav = [[UINavigationController alloc] initWithRootViewController:self.taskListViewController];
    
    //personal center
    self.personalCenterVC = [[PersonalCenterViewController alloc] initWithNibName:@"PersonalCenterViewController"
                                                                           bundle:nil];
    self.personalCenterRootNavCtrl = [[UINavigationController alloc] initWithRootViewController:self.personalCenterVC];
    
    //exchange center
    self.exchangeVC = [[ExchangeCenterViewController alloc] initWithNibName:@"ExchangeCenterViewController"
                                                                     bundle:nil];
    self.exchangeRootNavCtrl = [[UINavigationController alloc]initWithRootViewController:self.exchangeVC];
    
    //help
    self.helpVC = [[HelpViewController alloc]initWithNibName:@"HelpViewController" bundle:nil];
    self.helpRootNavCtrl = [[UINavigationController alloc] initWithRootViewController:_helpVC];
    
    [self customUIAppearance];
    
    self.tabBarCtrl = [[UITabBarController alloc] init];
    self.tabBarCtrl.viewControllers = @[self.taskListRootNav,
                                        self.personalCenterRootNavCtrl,
                                        self.exchangeRootNavCtrl,
                                        self.helpRootNavCtrl];
    
    self.window.rootViewController = self.tabBarCtrl;
    
    [self.window makeKeyAndVisible];

    return YES;
}



#pragma mark prive

- (void)getedIPAddress:(NSNotification*)notification
{
    NSString *currentIP = notification.object;
    self.ipListRequest = [[IPAddressListRequest alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
    [self.ipListRequest getIPAddressOfTheLimitSuccess:^(NSArray *ipList) {
        
        for (NSString *ipAddress in ipList) {
            
            if ([ipAddress isEqualToString:currentIP]) {
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"IP禁用"
                                                          message:@"你的IP已被禁用"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil, nil];
                [av show];

            }
        }
        
    } Failed:^(NSError *error) {
        
    }];
}

- (void)setupDeviceID
{
    NSString *udid = [LB_DeviceInfo getUDID];
    if (udid) {
        [GVUserDefaults standardUserDefaults].theOnlyDeviceNumber = udid;
        [GVUserDefaults standardUserDefaults].isJaBreak = YES;
    }else{
        
        if ([LB_DeviceInfo serialNumber]) {
            NSString *sn = [LB_DeviceInfo serialNumber];
            [GVUserDefaults standardUserDefaults].theOnlyDeviceNumber = sn;
            [GVUserDefaults standardUserDefaults].isJaBreak = NO;
            
        }else{
            //open uuid
            NSString *deviceNumber = [OpenUDID value];
            [GVUserDefaults standardUserDefaults].theOnlyDeviceNumber = deviceNumber;
            [GVUserDefaults standardUserDefaults].isJaBreak = NO;
        }
    }

}

- (void)customUIAppearance
{
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    [[UITabBar appearance]setBackgroundImage:[UIImage imageNamed:@"tabBar"]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }
                                             forState:UIControlStateHighlighted];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark UIAlertViewDelegate
//禁用IP 退出程序
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}

@end
