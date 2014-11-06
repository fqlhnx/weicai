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
#import "NSString+conversionUserID.h"

#import "IPAddressController.h"
#import "ExchangeRecordItem.h"
#import "ExchangeRecordCell.h"

#import "SVPullToRefresh.h"
#import "RETableViewManager.h"
#import "MarqueeLabel.h"
#import "NSString+BeeExtension.h"
#import "SVProgressHUD.h"
#import "BeeDeviceInfo.h"
#import "GVUserDefaults+Setting.h"
#import "NSString+LBExtension.h"

static NSString *ipAddress;

#define exchangeConditions 500
static NSString *userIntegral;

@interface ExchangeCenterViewController ()

@property (nonatomic,weak)IBOutlet UIButton *button1;
@property (nonatomic,weak)IBOutlet UIButton *button2;

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
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetIP:) name:DidGetCurrentIPAddress object:nil];
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
    self.edgesForExtendedLayout = UIRectEdgeNone;

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
    [self.tableViewManger registerClass:NSStringFromClass([ExchangeRecordItem class])
             forCellWithReuseIdentifier:NSStringFromClass([ExchangeRecordCell class])];
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"最新兑换记录"];
    [self.tableViewManger addSection:section];
    
    [self.listView triggerPullToRefresh];
    
    //点击其他空白处收回键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
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
    
    
    //是否是邮箱或是手机号
    BOOL isEmail = [_aliPayAccountField.text isEmail];
    BOOL isPhoneNum = [_aliPayAccountField.text isPhoneNumber];
    
    if (isEmail || isPhoneNum) {
        //积分条件
        if (userIntegral.integerValue >= exchangeConditions)
        {
            __weak ExchangeCenterViewController *weakSelf = self;
            //兑换比例100 = 1元;
            NSInteger integralMultiples =    userIntegral.integerValue / 100;
            [_exchangeAPI applicationForConversionWithUserName:[GVUserDefaults standardUserDefaults].userID
                                                        target:aliPay
                                                        fromIP:ipAddress
                                                      integral:(integralMultiples * 100)
                                                        amount:integralMultiples
                                                prepaidAccount:aliPayAccount
                                                       success:^{
                                                    //to do
                                                    [SVProgressHUD showSuccessWithStatus:@"支付宝提醒申请成功"];
                                                           //扣分
                                                           NSString *remainingIntegral = [NSString stringWithFormat:@"%d",userIntegral.integerValue - (integralMultiples * 100)];
                                                           userIntegral = remainingIntegral;

                                                    //刷新余额
                                                    [weakSelf refreshUserIntegral];
                                                           [weakSelf unlockExchangeButtons];
                                                           
                                                   
                                                       } failure:^(NSError *error) {
                                                    //tudo
                                                           [weakSelf unlockExchangeButtons];
                                                }];
            
            //锁定兑换按钮
            [self lockExchangeButtons];
            
        }
        else
        {
            NSString *errStr = [NSString stringWithFormat:@"账户余额%d元以上才能兑换",exchangeConditions/100];
            [SVProgressHUD showErrorWithStatus:errStr];
        }

    }else{
        [SVProgressHUD showErrorWithStatus:@"支付宝账户格式不正确"];
    }
    
    [_aliPayAccountField resignFirstResponder];
    
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
    
    //判断手机号格式是否正确
    BOOL isPhoneNum = [_phoneNumField.text isPhoneNumber];
    if (isPhoneNum) {
        //查询积分看是否满足兑换条件
        if (userIntegral.integerValue >= exchangeConditions) {
            
            NSInteger integralMultiples =    userIntegral.integerValue / 100;
            __weak ExchangeCenterViewController *weakSelf = self;

            [_exchangeAPI applicationForConversionWithUserName:[GVUserDefaults standardUserDefaults].userID
                                                        target:phoneNumber
                                                        fromIP:ipAddress
                                                      integral:(integralMultiples *100)
                                                        amount:integralMultiples
                                                prepaidAccount:telNumber success:^{

                                                    [SVProgressHUD showSuccessWithStatus:@"手机充值申请成功"];
                                                    //扣分
                                                    NSString *remainingIntegral = [NSString stringWithFormat:@"%d",userIntegral.integerValue - (integralMultiples * 100)];
                                                    
                                                    userIntegral = remainingIntegral;
                                                    [weakSelf refreshUserIntegral];
                                                    
                                                    [weakSelf unlockExchangeButtons];
                                                    
                                                } failure:^(NSError *error) {
                                                    
                                                    [weakSelf unlockExchangeButtons];
                                                }];
            
            //禁用兑换按钮
            [self lockExchangeButtons];

        }
        else
        {
            NSString *errStr = [NSString stringWithFormat:@"账户余额%d元以上才能兑换",exchangeConditions/100];
            [SVProgressHUD showErrorWithStatus:errStr];
        }

    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确"];
    }
    
    [_phoneNumField resignFirstResponder];

}

#pragma mark prive methods

- (void)getTheLatestExchangeRecords
{
    [_exchangeAPI getTheLatestExchangeRecords:^(NSArray *records) {
        
        [self.tableViewManger removeAllSections];
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"最新兑换记录"];
        [self.tableViewManger addSection:section];
        
        //刷新界面
        for (ExchangeInfo *exchangeInfo in records)
        {
            
            NSString *target = nil;
            //1 代表支付宝提现
            if ([exchangeInfo.exchange_target isEqualToString:@"1"]) {
                target = @"支付宝提现";
            }else{
                target = @"手机话费充值";
            }
            
            NSString *exchangeTime = nil;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:exchangeInfo.created.integerValue];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            exchangeTime = [dateFormatter stringFromDate:date];
            
            NSString *RMB = [NSString stringWithFormat:@"%ld元",(long)(exchangeInfo.integral.integerValue / 100)];
            NSString *userID = exchangeInfo.telmember_id;
            NSString *info = [NSString stringWithFormat:@"%@%@",target,RMB];
            ExchangeRecordItem *item = [[ExchangeRecordItem alloc]initWithUserID:userID
                                                                    ExchangeInfo:info
                                                                       timeValue:exchangeTime];
            item.cellHeight = 26.f;
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
        
        userIntegral = totalIntegral;

        if ([totalIntegral isEqualToString:@"0"]) {
            _userIntegral.text = @"0元";
        }else
        {
            NSString *yuan = [NSString stringWithFormat:@"%ld",(long)(totalIntegral.integerValue / 100)];
            NSString *jiao = [NSString stringWithFormat:@"%ld",(long)(totalIntegral.integerValue % 100 / 10)];
            NSString *fen = [NSString stringWithFormat:@"%ld",(long)(totalIntegral.integerValue %100 % 10 %10)];
            _userIntegral.text = [NSString stringWithFormat:@"%@.%@%@元",yuan,jiao,fen];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)hideKeyboard
{
    [_phoneNumField resignFirstResponder];
    [_aliPayAccountField resignFirstResponder];
}

- (void)lockExchangeButtons
{
    self.button1.enabled = NO;
    self.button2.enabled = NO;
}

- (void)unlockExchangeButtons
{
    self.button1.enabled = YES;
    self.button2.enabled = YES;
}

- (void)didGetIP:(NSNotification*)notification
{
    ipAddress = notification.object;
}
@end
