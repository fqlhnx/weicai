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
#import "OpenUDID.h"
#import "ServerConfig.h"
#import "ChannelInfo.h"

//各大广告平台SDK头文件
#import "DMOfferWallManager.h"
#import "ZKcmoneZKcmtwo.h"
#import <WPLib/AppConnect.h>
#import "OfferWall.h"

#import "YouMiConfig.h"
#import "YouMiWall.h"
#import "MyOfferAPI.h"

#import "CSAppZone.h"
#import "ChanceAd.h"

#import "RETableViewManager.h"
#import "MarqueeLabel.h"
#import "RMMapper.h"
#import "SVPullToRefresh.h"
#import "GVUserDefaults+Setting.h"
#import "JHTickerView.h"

@interface TaskListViewController ()<DMOfferWallManagerDelegate,MyOfferAPIDelegate,OfferWallDelegate,RETableViewManagerDelegate>

@property (nonatomic,weak)IBOutlet UITableView *listView;
@property (nonatomic,weak)IBOutlet JHTickerView *scrollLabel;
@property (nonatomic,strong) ScoreLabel *scoreLabel;

@property (nonatomic,strong) RETableViewManager *tableViewMager;

@property (nonatomic,strong)DMOfferWallManager *duoMengOfferWall;

@property (nonatomic,strong)TaskCenterAPI *taskCenterRequest;
@property (nonatomic,strong)PersonalCenterAPI *personalCenterAPI;

@property (nonatomic,strong)NSArray *allChannels;

@end

@implementation TaskListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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

    //初始化米迪
    [MyOfferAPI setAppPublisher:MiDiAppPID
                  withAppSecret:MiDiAppSecret];
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
    
}


- (void)initNavBarItems
{
    NSString *userID = [GVUserDefaults standardUserDefaults].userID;
    
    [_taskCenterRequest getIntegral:userID success:^(NSString *totalIntegral) {
        
        self.scoreLabel = [[ScoreLabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        self.scoreLabel.didTouchedBlock = ^()
        {
            NSLog(@"label touched");
            //刷新积分
        };
        self.scoreLabel.text = [NSString stringWithFormat:@"%@积分",totalIntegral];
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
            
        }];

    }];
}

- (void)getuserID
{
    __weak TaskListViewController *weakSelf = self;
    _personalCenterAPI = [[PersonalCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
    [_personalCenterAPI getUserID:[OpenUDID value]
                        competion:^(NSString *uID, NSError *error)
    {
        if (!error) {
            [GVUserDefaults standardUserDefaults].userID = uID;
            [weakSelf advertisingPlatformInitWithUserID:uID];
        }
        
        [self initNavBarItems];
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
    
    [self setupScrollLabel];
    [self setupListView];
    
    if ([GVUserDefaults standardUserDefaults].userID) {
        
        NSString *uid = [GVUserDefaults standardUserDefaults].userID;
        [self advertisingPlatformInitWithUserID:uid];
        [self initNavBarItems];
        
    }else{
        [self getuserID];
    }
    
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
            NSInteger channelID = channel.id.integerValue;
            switch (channelID) {
                case ChuKongPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName
                                                             accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                                                                 [[CSAppZone sharedAppZone]showAppZoneWithScale:0.9];
                                                             }];
                    item.detailLabelText = subName;
                    [section addItem:item];
                    break;
                }
                case WanPuPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                        [AppConnect showList:weakSelf];
                    }];
                    item.detailLabelText = subName;
                    [section addItem:item];
                    break;
                }
                case DianRuPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                        [OfferWall showOfferWall:weakSelf];
                    }];
                    item.detailLabelText = subName;
                    [section addItem:item];
                    break;
                }
                case AnWoPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                        ZKcmoneOWPresentZKcmtwo(anwoPID, weakSelf);
                    }];
                    item.detailLabelText = subName;
                    [section addItem:item];

                    break;
                }
                case YouMiPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                        [YouMiWall showOffers:YES didShowBlock:^{
                            
                        } didDismissBlock:^{
                            
                        }];
                    }];
                    item.detailLabelText = subName;
                    [section addItem:item];
                    break;
                }
                case MiDiPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                        [MyOfferAPI showAppOffers:weakSelf withDelegate:self];
                    }];
                    item.detailLabelText = subName;
                    [section addItem:item];
                    break;
                }
                case DuoMengPlatform:
                {
                    RETableViewItem *item = [RETableViewItem itemWithTitle:channelName accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                        [_duoMengOfferWall presentOfferWallWithViewController:weakSelf type:eDMOfferWallTypeList];
                    }];
                    item.detailLabelText = subName;
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
    [self.scrollLabel resume];
    

}

@end
