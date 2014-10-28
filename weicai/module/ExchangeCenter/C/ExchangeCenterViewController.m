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
#import "ExchangeInfo.h"

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
@property (nonatomic,weak)IBOutlet UIImageView *aliPayFieldBG;
@property(nonatomic,weak)IBOutlet UITextField *phoneNumField;
@property (nonatomic,weak)IBOutlet UIImageView *phoneFieldBG;

@property(nonatomic,weak)IBOutlet UITableView *listView;

@property (nonatomic,weak)IBOutlet UILabel *userIntegral;
@property(nonatomic,strong) RETableViewManager *tableViewManger;

@property(nonatomic,strong)ExchangeCenterAPI *exchangeAPI;
@property(nonatomic,strong)TaskCenterAPI *taskCenterAPI;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation ExchangeCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [[UIImage imageNamed:@"item3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"item3Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30.f
                                     target:self
                                   selector:@selector(refreshUserIntegral)
                                   userInfo:nil repeats:YES];
    
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
    
    self.aliPayFieldBG.image = [[UIImage imageNamed:@"textFieldBG"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    self.phoneFieldBG.image = [[UIImage imageNamed:@"textFieldBG"]stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    
    // Do any additional setup after loading the view from its nib.
    //获取ip地址
    [BeeDeviceInfo connectedToTheInternetToGetIPAddress:^(NSString *ipAddr, NSError *error) {
        if (!error) {
            ipAddress = ipAddr;
        }
        
    }];

    //刷新用户积分数额
    [self refreshUserIntegral];
    
    __weak ExchangeCenterViewController *weakSelf = self;
    //查看系统前50名兑换信息
    [self.listView addPullToRefreshWithActionHandler:^{
        
        [weakSelf getTheLatestExchangeRecords];
    }];
    
    self.tableViewManger = [[RETableViewManager alloc] initWithTableView:self.listView];
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"最新兑换记录"];
    [self.tableViewManger addSection:section];
    
    [self.listView triggerPullToRefresh];
    
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
                                                amount:2
                                        prepaidAccount:aliPayAccount success:^{
                                            //to do
                                        } failure:^(NSError *error) {
                                            //tudo
                                        }];
    //条件满足调用积分兑换API
    
}

//手机充值申请
- (IBAction)applyForMorePhoneCredit
{
    //是否为空
    NSString *telNumber = _phoneNumField.text;
    if ([telNumber isEmpty]) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    //不为空的话，查询积分看是否满足兑换条件
    [_exchangeAPI applicationForConversionWithUserName:[GVUserDefaults standardUserDefaults].userID
                                                target:phoneNumber
                                                fromIP:ipAddress integral:1
                                                amount:2
                                        prepaidAccount:telNumber success:^{
                                            
                                        } failure:^(NSError *error) {
                                            
                                        }];

}

#pragma mark prive methods

- (void)getTheLatestExchangeRecords
{
    [_exchangeAPI getTheLatestExchangeRecords:^(NSArray *records) {
        
        [self.tableViewManger removeAllSections];
        RETableViewSection *section = [RETableViewSection section];
        [self.tableViewManger addSection:section];
        
        //刷新界面
        for (ExchangeInfo *exchangeInfo in records)
        {
            RETableViewItem *item = [RETableViewItem itemWithTitle:[NSString stringWithFormat:@"%@在平台%@兑换，耗费%@积分",exchangeInfo.telmember_id,exchangeInfo.exchange_target,exchangeInfo.integral]];
            [section addItem:item];
        }
        [self.listView.pullToRefreshView stopAnimating];
        
        [self.listView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.listView.pullToRefreshView stopAnimating];
    }];
    
}

- (void)refreshUserIntegral
{
    NSString *userID = [GVUserDefaults standardUserDefaults].userID;
    [_taskCenterAPI getIntegral:userID success:^(NSString *totalIntegral) {
        
        _userIntegral.text = totalIntegral;
        
    } failure:^(NSError *error) {
        
    }];
}


@end
