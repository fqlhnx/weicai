//
//  PersonalCenterViewController.m
//  weicai
//
//  Created by liuhongnian on 14-9-28.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterAPI.h"
#import "ServerConfig.h"

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


@end

@implementation PersonalCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"个人中心";
        _personalCenterAPI = [[PersonalCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
    }
    return self;
}

#pragma mark timers methods

- (void)refreshBalance
{
    NSLog(@"%s",__FUNCTION__);
    
    //调用查询用户剩余积分API
    
    //成功刷新显示
    //失败给出提醒
}

- (void)refreshTotalPoints
{
    NSLog(@"%s",__FUNCTION__);
    
    //调用查询系统累计发放API
//    [_personalCenterAPI getTodayIntegral];
    //成功 显示总发放
    
    //失败 提醒
}

- (void)startTimers
{
    self.balanceTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(refreshBalance)
                                                       userInfo:nil
                                                        repeats:YES];

    
    self.totalPointTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
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
    // Do any additional setup after loading the view from its nib.
    
    //初始化列表
    self.tableViewMager = [[RETableViewManager alloc] initWithTableView:self.myList];
    RETableViewSection *oneSection = [RETableViewSection section];
    [self.tableViewMager addSection:oneSection];
    
    [oneSection addItem:[RETableViewItem itemWithTitle:@"收益明细"
                                        accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                     selectionHandler:^(RETableViewItem *item)
    {
#warning test
        [_personalCenterAPI integralDetail:@"tangwei" page:@"1"];
        [item deselectRowAnimated:YES];
    }]];
    
    [oneSection addItem:[RETableViewItem itemWithTitle:@"兑换记录"
                                        accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                     selectionHandler:^(RETableViewItem *item)
    {
#warning test
        [_personalCenterAPI queryExchangeDetailWithUserID:@"tangwei" page:@"1"];
        [item deselectRowAnimated:YES];
        
    }]];
    
    [_personalCenterAPI getNewsDescription];
    //初始化定时器服务
    [self startTimers];
    
    //获取用户ID
    NSString *uuid = [OpenUDID value];
    [_personalCenterAPI getUserID:uuid
                        competion:^(NSString *uID, NSError *error) {
        
                            if (!error) {
                                //刷新用户ID
                                _userID.text = uID;
                            }
                            
    }];
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
