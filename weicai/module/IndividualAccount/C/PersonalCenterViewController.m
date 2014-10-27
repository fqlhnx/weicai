//
//  PersonalCenterViewController.m
//  weicai
//
//  Created by liuhongnian on 14-9-28.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "IntegralDetailsViewController.h"
#import "ExchangeDetailViewController.h"
#import "TaskCenterAPI.h"
#import "PersonalCenterAPI.h"
#import "ServerConfig.h"
#import "IPAddressController.h"

#import "BeeDeviceInfo.h"
#import "MarqueeLabel.h"
#import "RETableViewManager.h"
#import "OpenUDID.h"

@interface PersonalCenterViewController ()

@property (nonatomic,weak)IBOutlet UILabel *userID;
@property (nonatomic,weak)IBOutlet UILabel *balanceLabel;
@property (nonatomic,weak)IBOutlet UILabel *totalPoint;

@property (nonatomic,weak)IBOutlet UITableView *myList;
@property (nonatomic,strong)RETableViewManager *tableViewMager;

@property (nonatomic,weak)IBOutlet MarqueeLabel *scrolLabel;

@property (nonatomic,strong)NSTimer *balanceTimer;
@property (nonatomic,strong)NSTimer *totalPointTimer;

@property (nonatomic,strong)PersonalCenterAPI *personalCenterAPI;
@property(nonatomic,strong)TaskCenterAPI *taskCenterAPI;


@end

@implementation PersonalCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [[UIImage imageNamed:@"item2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"item2Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        _personalCenterAPI = [[PersonalCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
        self.taskCenterAPI = [[TaskCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];

    }
    return self;
}

#pragma mark timers methods

- (void)refreshBalance
{
    NSLog(@"%s",__FUNCTION__);
    
    //调用查询用户剩余积分API
    [_taskCenterAPI getIntegral:_userID.text success:^(NSString *totalIntegral) {
        //成功刷新显示
        _balanceLabel.text = totalIntegral;
    } failure:^(NSError *error) {
        //失败给出提醒
    }];
}

- (void)refreshTotalPoints
{
    
    [_personalCenterAPI getTodayIntegral:^(NSNumber *todayIntegral, NSError *error) {
        
        if (!error) {
            _totalPoint.text = [NSString stringWithFormat:@"%ld",(long)todayIntegral.integerValue];
            
        }
    }];

}

- (void)startTimers
{
    self.balanceTimer = [NSTimer scheduledTimerWithTimeInterval:30.f
                                                         target:self
                                                       selector:@selector(refreshBalance)
                                                       userInfo:nil
                                                        repeats:YES];

    
    self.totalPointTimer = [NSTimer scheduledTimerWithTimeInterval:30.f
                                                            target:self
                                                          selector:@selector(refreshTotalPoints)
                                                          userInfo:nil
                                                           repeats:YES];
}

- (void)stopTimers
{
    [self.balanceTimer invalidate];
    self.balanceTimer = nil;
    [self.totalPointTimer invalidate];
    self.totalPointTimer = nil;
}

#pragma mark view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak PersonalCenterViewController *weakSelf = self;
    //初始化列表
    self.tableViewMager = [[RETableViewManager alloc] initWithTableView:self.myList];
    RETableViewSection *oneSection = [RETableViewSection section];
    [self.tableViewMager addSection:oneSection];
    
    [oneSection addItem:[RETableViewItem itemWithTitle:@"收益明细"
                                        accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                     selectionHandler:^(RETableViewItem *item)
    {        
        IntegralDetailsViewController *integralDetailsVC = [[IntegralDetailsViewController alloc] initWithNibName:@"IntegralDetailsViewController" bundle:nil];
        integralDetailsVC.userid = _userID.text;
        [weakSelf.navigationController pushViewController:integralDetailsVC animated:YES];
        [item deselectRowAnimated:YES];
    }]];
    
    [oneSection addItem:[RETableViewItem itemWithTitle:@"兑换记录"
                                        accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                     selectionHandler:^(RETableViewItem *item)
    {
        ExchangeDetailViewController *vc = [[ExchangeDetailViewController alloc] initWithNibName:@"ExchangeDetailViewController" bundle:nil];
        vc.userid = _userID.text;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
        [item deselectRowAnimated:YES];
        
    }]];
    
    
    
    //获取描述信息
    [_personalCenterAPI getNewsDescription];
    
    //初始化定时器服务
    [self startTimers];
    
    //获取用户ID
    NSString *uuid = [OpenUDID value];
    NSString *ip = [IPAddressController sharedInstance].currentIP;
    [_personalCenterAPI getUserID:uuid
                           fromIP:ip
                        competion:^(NSString *uID, NSError *error) {
        
                            if (!error) {
                                //刷新用户ID
                                _userID.text = uID;
                                //刷新用户剩余积分
                                [self refreshBalance];
                            }

    }];
    
    //获取累计方法积分数
    [self refreshTotalPoints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimers];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopTimers];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
