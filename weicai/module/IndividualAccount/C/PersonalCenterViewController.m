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
#import "NSString+conversionUserID.h"

#import "DescriptionInfoCell.h"
#import "DescriptionInfoItem.h"

#import "BeeDeviceInfo.h"
#import "MarqueeLabel.h"
#import "NSString+LBExtension.h"
#import "RETableViewManager.h"
#import "OpenUDID.h"
#import "GVUserDefaults+Setting.h"

@interface PersonalCenterViewController ()

@property (nonatomic,weak)IBOutlet UILabel *userID;
@property (nonatomic,strong)NSString *myUserID;
@property (nonatomic,weak)IBOutlet UILabel *balanceLabel;
@property (nonatomic,weak)IBOutlet UILabel *totalPoint;

@property (nonatomic,weak)IBOutlet UITableView *myList;
@property (nonatomic,strong)RETableViewManager *tableViewMager;
@property (nonatomic,strong)RETableViewSection *section;

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
        
        self.title = @"个人中心";
        _personalCenterAPI = [[PersonalCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
        self.taskCenterAPI = [[TaskCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];

        //
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(didGetIPAddress:)
                                                    name:DidGetCurrentIPAddress
                                                  object:nil];

    }
    return self;
}

#pragma mark timers methods

- (void)refreshBalance
{
    NSLog(@"%s",__FUNCTION__);
    
    //调用查询用户剩余积分API
    [_taskCenterAPI getIntegral:_myUserID success:^(NSString *totalIntegral) {
        //成功刷新显示
        if ([totalIntegral isEqualToString:@"0"]) {
            _balanceLabel.text = @"0元";
        }else
        {
            NSString *yuan = [NSString stringWithFormat:@"%d",totalIntegral.integerValue / 100];
            NSString *jiao = [NSString stringWithFormat:@"%d",totalIntegral.integerValue % 100 / 10];
            NSString *fen = [NSString stringWithFormat:@"%d",totalIntegral.integerValue %100 % 10 %10];
            _balanceLabel.text = [NSString stringWithFormat:@"%@.%@%@元",yuan,jiao,fen];
        }

    } failure:^(NSError *error) {
        //失败给出提醒
    }];
}

- (void)refreshTotalPoints
{
    
    [_personalCenterAPI getTodayIntegral:^(NSNumber *todayIntegral, NSError *error) {
        
        if (!error) {
            _totalPoint.text = [NSString stringWithFormat:@"%ld",(long)todayIntegral.integerValue];
            if (todayIntegral.integerValue == 0) {
                _totalPoint.text = @"0元";
            }else
            {
                NSString *yuan = [NSString stringWithFormat:@"%d",todayIntegral.integerValue / 100];
                NSString *jiao = [NSString stringWithFormat:@"%d",todayIntegral.integerValue % 100 / 10];
                NSString *fen = [NSString stringWithFormat:@"%d",todayIntegral.integerValue %100 % 10 %10];
                _totalPoint.text = [NSString stringWithFormat:@"%@.%@%@元",yuan,jiao,fen];
            }

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
    
    [self setupListView];
    
    //初始化定时器服务
    [self startTimers];
    
    //获取累计方法积分数
    [self refreshTotalPoints];
    
    _userID.text = [_myUserID conversionIDbyUserType:defaultUser];
    if (_myUserID) {
        [self refreshBalance];
    }
    //获取描述信息
    [_personalCenterAPI getNewsDescriptionSuccess:^(NSString *desString) {
        
        //算高度
        CGSize stringSize = [desString sizeWithFont:[UIFont systemFontOfSize:18.f]
                                            byWidth:CGRectGetWidth(self.myList.frame)];
        NSLog(@"%f",stringSize.height);
        //添加item
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"系统公告"];
        DescriptionInfoItem *item = [DescriptionInfoItem itemWithTitle:desString
                                                 accessoryType:UITableViewCellAccessoryNone
                                              selectionHandler:^(RETableViewItem *item) {
                                                  
                                              }];
        item.cellHeight = stringSize.height + 50.f;
        [section addItem:item];
        [self.tableViewMager insertSection:section atIndex:1];
        [self.myList reloadData];
        
        
    } failed:^(NSError *error) {
        
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

#pragma mark prive

- (void)setupListView
{
    __weak PersonalCenterViewController *weakSelf = self;
    //初始化列表
    self.tableViewMager = [[RETableViewManager alloc] initWithTableView:self.myList];
    [self.tableViewMager registerClass:NSStringFromClass([DescriptionInfoItem class])
            forCellWithReuseIdentifier:NSStringFromClass([DescriptionInfoCell class])];
    
    _section = [RETableViewSection section];
    [self.tableViewMager addSection:_section];
    
    [_section addItem:[RETableViewItem itemWithTitle:@"收益明细"
                                         accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                      selectionHandler:^(RETableViewItem *item)
                         {
                             IntegralDetailsViewController *integralDetailsVC = [[IntegralDetailsViewController alloc] initWithNibName:@"IntegralDetailsViewController" bundle:nil];
                             integralDetailsVC.userid = _myUserID;
                             [weakSelf.navigationController pushViewController:integralDetailsVC animated:YES];
                             [item deselectRowAnimated:YES];
                         }]];
    
    [_section addItem:[RETableViewItem itemWithTitle:@"兑换记录"
                                         accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                      selectionHandler:^(RETableViewItem *item)
                         {
                             ExchangeDetailViewController *vc = [[ExchangeDetailViewController alloc] initWithNibName:@"ExchangeDetailViewController" bundle:nil];
                             vc.userid = _myUserID;
                             [weakSelf.navigationController pushViewController:vc animated:YES];
                             
                             [item deselectRowAnimated:YES];
                             
                         }]];

}

- (void)didGetIPAddress:(NSNotification*)notification
{
    NSString *ip = notification.object;
    
    //获取用户ID
    NSString *uuid = [OpenUDID value];
    [_personalCenterAPI getUserID:uuid
                           fromIP:ip
                        competion:^(NSString *uID, NSError *error) {
                            
                            if (!error) {
                                _myUserID = uID;
                                //刷新显示ID
                                _userID.text = [uID conversionIDbyUserType:defaultUser];
                                //刷新用户剩余积分
                                [self refreshBalance];
                                
                                //本地保存UID
                                [GVUserDefaults standardUserDefaults].userID = uID;
                                //内存保存UID
                                
                                
                            }
                            
                        }];

}

@end
