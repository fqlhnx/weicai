//
//  ExchangeCenterViewController.m
//  weicai
//
//  Created by liuhongnian on 14-9-28.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "ExchangeCenterViewController.h"
#import "ExchangeCenterAPI.h"
#import "TaskCenterAPI.h"
#import "ServerConfig.h"

#import "SVPullToRefresh.h"
#import "RETableViewManager.h"
#import "MarqueeLabel.h"
#import "NSString+BeeExtension.h"
#import "SVProgressHUD.h"
#import "BeeDeviceInfo.h"
#import "GVUserDefaults+Setting.h"

static NSString *ipAddress;

@interface ExchangeCenterViewController ()

@property(nonatomic,weak)IBOutlet UITextField *aliPayAccountField;
@property(nonatomic,weak)IBOutlet UITextField *phoneNumField;

@property(nonatomic,weak)IBOutlet UITableView *listView;

@property (nonatomic,weak)IBOutlet UILabel *userIntegral;
@property(nonatomic,strong) RETableViewManager *tableViewManger;

@property(nonatomic,strong)ExchangeCenterAPI *exchangeAPI;
@property(nonatomic,strong)TaskCenterAPI *taskCenterAPI;

@end

@implementation ExchangeCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"兑换中心";
        
        _exchangeAPI = [[ExchangeCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
        _taskCenterAPI = [[TaskCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //定时器开启 （定时更新用户积分，和最新兑换消息）
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //定时器关闭（停止更新用户积分，和最新兑换消息）
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //刷新用户积分数额
    [self refreshUserIntegral];
    //查看系统前50名兑换信息
    [self.listView addPullToRefreshWithActionHandler:^{
        
        [_exchangeAPI getTheLatestExchangeRecords];
    }];
    self.tableViewManger = [[RETableViewManager alloc] initWithTableView:self.listView];
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"最新兑换记录"];
    [self.tableViewManger addSection:section];
    
    [section addItem:[RETableViewItem itemWithTitle:@"ceshi" accessoryType:UITableViewCellAccessoryNone
                                  selectionHandler:^(RETableViewItem *item) {
                                      
                                  }]];
    
#warning test
    [_exchangeAPI applicationForConversionWithUserName:@"admin"
                                                target:aliPay
                                                fromIP:@"10.1.89.3"
                                              integral:100
                                                amount:100];
    
    //获取ip地址
    [BeeDeviceInfo connectedToTheInternetToGetIPAddress:^(NSString *ipAddr, NSError *error) {
        ipAddress = ipAddr;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ui actions
//支付宝申请
- (IBAction)applyForAliPay
{
    NSString *aliPayAccount = _aliPayAccountField.text;
    //是否为空
    if ([aliPayAccount isEmpty]) {
        [SVProgressHUD showErrorWithStatus:@"支付宝账户名不能为空"];
        return;
    }
    
    //不为空的话，查询积分看是否满足兑换条件
    [_exchangeAPI applicationForConversionWithUserName:[GVUserDefaults standardUserDefaults].userID
                                                target:aliPay
                                                fromIP:ipAddress
                                              integral:1
                                                amount:1];
    //条件满足调用积分兑换API
    
}

//手机充值申请
- (IBAction)applyForMorePhoneCredit
{
    //是否为空
    
    //不为空的话，查询积分看是否满足兑换条件
    
    //条件满足调用积分兑换API

    NSString *phoneNum = self.phoneNumField.text;
    BOOL empty = [phoneNum isEmpty];
    if (empty) {
        NSLog(@"手机号不能为空");
    }else{
        
    }
}

#pragma mark prive methods

- (void)refreshUserIntegral
{
    NSString *userID = [GVUserDefaults standardUserDefaults].userID;
    [_taskCenterAPI getIntegral:userID success:^(NSString *totalIntegral) {
        
        _userIntegral.text = totalIntegral;
    } failure:^(NSError *error) {
        
    }];
}


@end
