//
//  IntegralDetailsViewController.m
//  weicai
//
//  Created by liuhongnian on 14-10-17.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "IntegralDetailsViewController.h"
#import "TaskInfo.h"
#import "PersonalCenterAPI.h"
#import "ServerConfig.h"
#import "TaskInfo.h"

#import "SVPullToRefresh.h"
#import "RETableViewManager.h"

@interface IntegralDetailsViewController ()

@property (nonatomic,weak) IBOutlet UITableView *listView;
@property (nonatomic,strong)RETableViewManager *tableViewMager;

@property (nonatomic,strong)PersonalCenterAPI *personCenterAPI;

@property (nonatomic,strong)NSMutableArray *taskContents;


@end

@implementation IntegralDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"收益明细";
        
        _taskContents = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.personCenterAPI = [[PersonalCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
    
    self.tableViewMager = [[RETableViewManager alloc] initWithTableView:self.listView];
    
    __weak IntegralDetailsViewController *weakSelf = self;
    [self.listView addPullToRefreshWithActionHandler:^{
    
        NSAssert(_userid, @"user id null");
        [weakSelf.personCenterAPI integralDetail:_userid page:@"1" success:^(NSArray *results) {
            
            if (results.count > 0) {
                
                [_taskContents removeAllObjects];
                [_taskContents addObjectsFromArray:results];
                [weakSelf configListViewWithTasks:_taskContents];
                
            }
            [weakSelf.listView.pullToRefreshView stopAnimating];

        } failed:^(NSError *error) {
            
            [weakSelf.listView.pullToRefreshView stopAnimating];
        }];
        
    }];
    
    //开始刷新
    [self.listView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark prive

- (void)configListViewWithTasks:(NSArray *)tasks
{
    [self.tableViewMager removeAllSections];
    
    RETableViewSection *section = [RETableViewSection section];
    [self.tableViewMager addSection:section];
    
    //循环配置cell
    for (TaskInfo *taskObj in tasks) {
        
        NSString *timeStr = nil;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:taskObj.created.integerValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        timeStr = [dateFormatter stringFromDate:date];
        
        RETableViewItem * item = [RETableViewItem itemWithTitle:[NSString stringWithFormat:@"%@ %@积分  %@",taskObj.ad,taskObj.point,timeStr]];
        item.cellHeight = 30.f;
        [section addItem:item];
    }
    
    [self.listView reloadData];
    
}
@end
