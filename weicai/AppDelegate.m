//
//  AppDelegate.m
//  weicai
//
//  Created by liuhongnian on 14-9-28.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "AppDelegate.h"

#import "ExchangeCenterViewController.h"
#import "HelpViewController.h"
#import "PersonalCenterViewController.h"
#import "TaskListViewController.h"

@interface AppDelegate ()

@property (nonatomic,strong)UITabBarController *tabBarCtrl;

@property (nonatomic,strong)UINavigationController *taskListRootNav;
@property (nonatomic,strong)TaskListViewController *taskListViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    self.taskListViewController = [[TaskListViewController alloc] initWithNibName:@"TaskListViewController" bundle:nil];
    self.taskListRootNav = [[UINavigationController alloc] initWithRootViewController:self.taskListViewController];
    
    [self customUIAppearance];
    self.window.rootViewController = self.taskListRootNav;
    [self.window makeKeyAndVisible];
    
    [self advertisingPlatformInit];
    return YES;
}

- (void)customUIAppearance
{
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navigation_bg.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
}

- (void)advertisingPlatformInit
{
    
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

@end
