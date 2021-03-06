//
//  TaskListViewController.m
//  weicai
//
//  Created by liuhongnian on 14-9-28.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "TaskListViewController.h"
#import "ScoreLabel.h"
#import "ADConfig.h"
#import "TaskCenterAPI.h"
#import "PersonalCenterAPI.h"
#import "ServerConfig.h"
#import "ChannelInfo.h"
#import "IPAddressController.h"
#import "GVUserDefaults+generalData.h"
#import "NSString+conversionUserID.h"

//各大广告平台SDK头文件
#import "DMOfferWallManager.h"
#import "ZKcmoneZKcmtwo.h"
#import <WPLib/AppConnect.h>
#import "OfferWall.h"

#import "YouMiConfig.h"
#import "YouMiWall.h"

#import "CSAppZone.h"
#import "ChanceAd.h"
#import "JJSDK.h"
//midi
#import "MyOfferAPI.h"

//guo meng
#import "GuoMobWallViewController.h"

#import "RETableViewManager.h"
#import "MarqueeLabel.h"
#import "RMMapper.h"
#import "SVPullToRefresh.h"
#import "GVUserDefaults+Setting.h"
#import "JHTickerView.h"
#import "SVProgressHUD.h"

#define cellDefaultHeight 50.f

@interface TaskListViewController ()<DMOfferWallManagerDelegate,
OfferWallDelegate,
RETableViewManagerDelegate,
GuoMobWallDelegate>

@property (nonatomic,weak)IBOutlet UITableView *listView;
@property (nonatomic,weak)IBOutlet JHTickerView *scrollLabel;
@property (nonatomic,strong) ScoreLabel *scoreLabel;

@property (nonatomic,strong) RETableViewManager *tableViewMager;

@property (nonatomic,strong)DMOfferWallManager *duoMengOfferWall;

@property (nonatomic,strong)TaskCenterAPI *taskCenterRequest;
@property (nonatomic,strong)PersonalCenterAPI *personalCenterAPI;

@property (nonatomic,strong)GuoMobWallViewController *guoMengWallVC;

@property (nonatomic,strong)NSArray *allChannels;

@end

@implementation TaskListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.tabBarItem.image = [[UIImage imageNamed:@"tabbarItem1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBarItem1_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.title = @"任务中心";
        _taskCenterRequest = [[TaskCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
        
    }
    return self;
}

- (void)advertisingPlatformInitWithUserID:(NSString*)userID
{

    //多盟
    NSAssert(userID, @"userid is null");
    BOOL isZero = [userID isEqualToString:@"0"];
    NSAssert(!isZero, @"用户ID 是 0");
    
    BOOL isLegal = [userID hasPrefix:@"U"];
    NSAssert(isLegal, @"不合法");
    
    //初始化多盟积分墙
    self.duoMengOfferWall = [[DMOfferWallManager alloc]initWithPublisherID:duoMengPID
                                                                 andUserID:userID];
    self.duoMengOfferWall.delegate = self;
    
    //you mi
    [YouMiConfig launchWithAppID:YoumiAppID
                       appSecret:YoumiAppSecret];
    [YouMiConfig setUserID:userID];
    //wall init
    [YouMiWall enable];
    
    //点入
    [OfferWall initWithOfferWallDelegate:self];
    
    //米迪
    [MyOfferAPI setAppPublisher:MiDiAppPID withAppSecret:MiDiAppSecret];
    [MyOfferAPI setUserParam:userID];
    
    //万普
    [AppConnect getConnect:WPAPP_ID
                       pid:@"test"
                    userID:userID];
    
    //触控
    [ChanceAd startSession:ChuKongPID];
    [[CSAppZone sharedAppZone]loadAppZone:[CSADRequest request]];
    [ChanceAd setUserInfo:userID];
    //安沃
    ZKcmoneOWSetKeywords(@[userID]);
    
    //点乐
    [JJSDK requestJJSession:dianJoyAppID withUserID:userID];
    
    //guomeng
    self.guoMengWallVC = [[GuoMobWallViewController alloc] initWithId:@"k2pihlw4as74912"];
    self.guoMengWallVC.delegate = self;
    self.guoMengWallVC.OtherID = userID;
    
    //初始化积分墙列表
    [self setupListView];
    [self.listView triggerPullToRefresh];
}


- (void)initNavBarItems
{
    [NSTimer scheduledTimerWithTimeInterval:30.f
                                     target:self
                                   selector:@selector(refreshUserIntegral)
                                   userInfo:nil
                                    repeats:YES];
    
    NSString *userID = [GVUserDefaults standardUserDefaults].userID;
    
    [_taskCenterRequest getIntegral:userID success:^(NSString *totalIntegral) {
        
        self.scoreLabel = [[ScoreLabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        self.scoreLabel.didTouchedBlock = ^()
        {
            NSLog(@"label touched");
            //刷新积分
        };
        //成功刷新显示
        if ([totalIntegral isEqualToString:@"0"]) {
            self.scoreLabel.text = @"0元";
        }else
        {
            NSString *yuan = [NSString stringWithFormat:@"%ld",(long)(totalIntegral.integerValue / 100)];
            NSString *jiao = [NSString stringWithFormat:@"%ld",(long)(totalIntegral.integerValue % 100 / 10)];
            NSString *fen = [NSString stringWithFormat:@"%ld",(long)(totalIntegral.integerValue %100 % 10 %10)];
            self.scoreLabel.text = [NSString stringWithFormat:@"%@.%@%@元",yuan,jiao,fen];
        }
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.scoreLabel ];
        self.navigationItem.rightBarButtonItem = rightItem;

    } failure:^(NSError *error) {
        
    }];
    
}

- (void)setupScrollLabel
{
    self.scrollLabel.tickerSpeed = 30.;
    self.scrollLabel.direction = JHTickerDirectionLTR;
    [self.scrollLabel start];
}

- (void)setupListView
{
    self.tableViewMager = [[RETableViewManager alloc] initWithTableView:self.listView delegate:nil];

    [self.listView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    __weak TaskListViewController *weakSelf = self;
    
    [self.listView addPullToRefreshWithActionHandler:^{
        //刷新列表信息
        //获取列表
        [_taskCenterRequest getAllChannels:^(NSArray *channels) {
            
            NSMutableArray *channelArray = [NSMutableArray arrayWithCapacity:channels.count];
            for (NSDictionary *channel in channels) {
                RMMapper *channelObj = [RMMapper objectWithClass:[ChannelInfo class] fromDictionary:channel];
                [channelArray addObject:channelObj];
            }
            weakSelf.allChannels = [channelArray copy];
            
            [weakSelf configListView];
            
            [weakSelf.listView.pullToRefreshView stopAnimating];

            
        } failure:^(NSError *error) {
            
            
            [weakSelf.listView.pullToRefreshView stopAnimating];
            
        }];

    }];
}

- (void)getuserIDWithIPAddress:(NSString*)address
{
    __weak TaskListViewController *weakSelf = self;
    _personalCenterAPI = [[PersonalCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
    NSString *ip = address;
    NSString *udid = [GVUserDefaults standardUserDefaults].theOnlyDeviceNumber;
    [_personalCenterAPI getUserID:udid fromIP:ip competion:^(NSString *uID, NSError *error) {

        if (!error) {
            
            [GVUserDefaults standardUserDefaults].userID = uID;
            
            [weakSelf advertisingPlatformInitWithUserID:uID];
            
            [self initNavBarItems];

            }
        
    }];
}

#pragma mark view lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetIP:)
                                                name:DidGetCurrentIPAddress
                                              object:nil];
    
    [self setupScrollLabel];
    
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //刷新渠道列表
    [self.listView triggerPullToRefresh];
    //定时获取需要滚动显示的消息
    [self updateScrollLabelContent];

    [NSTimer scheduledTimerWithTimeInterval:30.f
                                     target:self
                                   selector:@selector(updateScrollLabelContent)
                                   userInfo:nil
                                    repeats:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark OfferWallDelegate

- (NSString *)applicationKey
{
    return @"0000071E1A0000B2";
}

-(NSString *)OfferWallAppUserId
{
    NSString *userID = [GVUserDefaults standardUserDefaults].userID;
    NSAssert(userID, @"user id is null");
    BOOL isLegal = [userID hasPrefix:@"U"];
    NSAssert(isLegal, @"用户名不合法");
    return userID;
}

/*
 用于消费积分结果的回调
 */
-(void)didReceiveSpendScoreResult:(BOOL)isSuccess
{
}

/*
 用于获取剩余积分结果的回调
 */
-(void)didReceiveGetScoreResult:(int)point
{
    
}


#pragma mark prive method

- (void)refreshUserIntegral
{
    
    [_taskCenterRequest getIntegral:[GVUserDefaults standardUserDefaults].userID success:^(NSString *totalIntegral) {
        
        //成功刷新显示
        if ([totalIntegral isEqualToString:@"0"]) {
            _scoreLabel.text = @"0元";
        }else
        {
            NSString *yuan = [NSString stringWithFormat:@"%ld",(long)(totalIntegral.integerValue / 100)];
            NSString *jiao = [NSString stringWithFormat:@"%ld",(long)(totalIntegral.integerValue % 100 / 10)];
            NSString *fen = [NSString stringWithFormat:@"%ld",(long)(totalIntegral.integerValue %100 % 10 %10)];
            _scoreLabel.text = [NSString stringWithFormat:@"%@.%@%@元",yuan,jiao,fen];
        }

        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didGetIP:(NSNotification*)notification
{
    [SVProgressHUD dismiss];
    
    if ([GVUserDefaults standardUserDefaults].userID) {
        
        NSString *uid = [GVUserDefaults standardUserDefaults].userID;
        
        [self advertisingPlatformInitWithUserID:uid];
        [self initNavBarItems];
        
    }
    else
    {
        NSString *ipadd = notification.object;
        [self getuserIDWithIPAddress:ipadd];
    }

}

- (void)configListView
{
    RETableViewSection *section = [RETableViewSection section];
    
    
    for (ChannelInfo *channel in self.allChannels)
    {
        NSString *isDisplay = channel.is_display;
        NSString *channelName = channel.channel_name;
        NSString *subName = channel.sub_name;
        
        __weak TaskListViewController *weakSelf = self;
        
        if ([isDisplay isEqualToString:@"1"])
        {

            PlatformName channelID = channel.id.integerValue;
            
            switch (channelID) {
                case ChuKongPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName
                                                             accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                                                                 [[CSAppZone sharedAppZone]showAppZoneWithScale:0.9];
                                                             }];
                    item.image = [UIImage imageNamed:@"taskCellIcon"];
                    item.style = UITableViewCellStyleSubtitle;
                    item.cellHeight = cellDefaultHeight;
                    [section addItem:item];
                    item.detailLabelText = subName;
                    
                    break;
                }
                case WanPuPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                        [AppConnect showList:weakSelf];
                    }];
                    item.image = [UIImage imageNamed:@"taskCellIcon"];
                    item.style = UITableViewCellStyleSubtitle;
                    item.detailLabelText = subName;
                    item.cellHeight = cellDefaultHeight;

                    [section addItem:item];
                    break;
                }
                case DianRuPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                        [OfferWall showOfferWall:weakSelf];
                    }];
                    item.image = [UIImage imageNamed:@"taskCellIcon"];
                    item.style = UITableViewCellStyleSubtitle;
                    item.cellHeight = cellDefaultHeight;

                    item.detailLabelText = subName;
                    [section addItem:item];
                    break;
                }
                case AnWoPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                        ZKcmoneOWPresentZKcmtwo(anwoPID, weakSelf);
                    }];
                    item.image = [UIImage imageNamed:@"taskCellIcon"];
                    item.style = UITableViewCellStyleSubtitle;
                    item.cellHeight = cellDefaultHeight;

                    item.detailLabelText = subName;
                    [section addItem:item];

                    break;
                }
                case YouMiPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                        [YouMiWall showOffers:YES didShowBlock:^{
                            
                        } didDismissBlock:^{
                            
                        }];
                    }];
                    item.image = [UIImage imageNamed:@"taskCellIcon"];
                    item.style = UITableViewCellStyleSubtitle;
                    item.cellHeight = cellDefaultHeight;

                    item.detailLabelText = subName;
                    [section addItem:item];
                    break;
                }
                case MiDiPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                        
                        [MyOfferAPI showAppOffers:weakSelf withDelegate:nil];
                    }];
                    
                    item.image = [UIImage imageNamed:@"taskCellIcon"];
                    item.style = UITableViewCellStyleSubtitle;
                    item.cellHeight = cellDefaultHeight;

                    item.detailLabelText = subName;
                    [section addItem:item];
                    break;
                }
                case DuoMengPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                        [_duoMengOfferWall presentOfferWallWithViewController:weakSelf type:eDMOfferWallTypeList];
                    }];
                    
                    item.image = [UIImage imageNamed:@"taskCellIcon"];
                    item.style = UITableViewCellStyleSubtitle;
                    item.cellHeight = cellDefaultHeight;

                    item.detailLabelText = subName;
                    [section addItem:item];
                    break;
                }
                case DianJoyPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                        [JJSDK showJJDiamondWithViewController:weakSelf];
                    }];
                    item.style = UITableViewCellStyleSubtitle;
                    item.image = [UIImage imageNamed:@"taskCellIcon"];
                    item.cellHeight = cellDefaultHeight;

                    item.detailLabelText = subName;
                    [section addItem:item];
                    
                    break;
                }
                case GuoMengPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                        
                        [_guoMengWallVC pushGuoMobWall:YES Hscreen:NO];
                    }];
                    item.style = UITableViewCellStyleSubtitle;
                    item.detailLabelText = subName;
                    item.image = [UIImage imageNamed:@"taskCellIcon"];
                    item.cellHeight = cellDefaultHeight;

                    [section addItem:item];
                    break;
                }
                default:
                {
                    NSLog(@"未知的渠道");
                    break;
                }
            }
        }else{
            break;
        }
            
    }
    
    [self.tableViewMager removeAllSections];
    [self.tableViewMager addSection:section];

    [self.listView reloadData];
}

- (void)updateScrollLabelContent
{
    //获取最新的滚动消息内容
    [self.taskCenterRequest getScrollContent:^(NSArray *contents, NSError *error) {
        
        self.scrollLabel.tickerStrings = contents;
        
    }];
    //跟新滚动标签内容
    if (self.scrollLabel.tickerStrings.count > 0) {
        [self.scrollLabel resume];

    }
    

}

@end
