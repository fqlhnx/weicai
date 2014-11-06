//
//  ExchangeDetailViewController.m
//  weicai
//
//  Created by liuhongnian on 14-10-17.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "ExchangeDetailViewController.h"
#import "PersonalCenterAPI.h"
#import "ServerConfig.h"
#import "Exchange.h"

#import "ExchangeRecordCell.h"
#import "ExchangeRecordItem.h"

#import "RETableViewManager.h"
#import "SVPullToRefresh.h"

@interface ExchangeDetailViewController ()

@property (nonatomic,weak)IBOutlet UITableView *listView;
@property (nonatomic,strong)RETableViewManager *tableViewMager;

@property (nonatomic,strong)PersonalCenterAPI *personCenterAPI;

@property (nonatomic,strong)NSMutableArray *allExchangeInfo;

@end

@implementation ExchangeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _personCenterAPI = [[PersonalCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
        self.title = @"兑换中心";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableViewMager = [[RETableViewManager alloc] initWithTableView:self.listView];
    [_tableViewMager registerClass:NSStringFromClass([ExchangeRecordItem class])
        forCellWithReuseIdentifier:NSStringFromClass([ExchangeRecordCell class])];
    
    _allExchangeInfo = [NSMutableArray array];
    
    __weak ExchangeDetailViewController *weakSelf = self;
    [self.listView addPullToRefreshWithActionHandler:^{
        NSAssert(_userid, @"userid null");
        
        [_personCenterAPI queryExchangeDetailWithUserID:_userid page:@"1" success:^(NSArray *results) {
            
            [_allExchangeInfo removeAllObjects];
            [_allExchangeInfo addObjectsFromArray:results];
            
            [weakSelf configListViewWithExchangeRecords:_allExchangeInfo];
            
            [weakSelf.listView.pullToRefreshView stopAnimating];
            
        } failed:^(NSError *error) {
            
            [weakSelf.listView.pullToRefreshView stopAnimating];
        }];
        
    }];
    
    [self.listView triggerPullToRefresh];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configListViewWithExchangeRecords:(NSArray*)exchange_records
{
    RETableViewSection *section = [RETableViewSection section];
    for (Exchange *exchangeInfo in exchange_records)
    {
        NSString *exchangeTime = nil;
        NSString *target = nil;
        if ([exchangeInfo.exchange_target isEqualToString:@"1"]) {
            target = @"支付宝提现";
        }else{
            target = @"手机话费充值";
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:exchangeInfo.created.integerValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        exchangeTime = [dateFormatter stringFromDate:date];

        NSString *RMB = [NSString stringWithFormat:@"%ld元",(long)(exchangeInfo.integral.integerValue / 100)];
        NSString *content = [NSString stringWithFormat:@"%@%@",target,RMB];
        
        ExchangeRecordItem *item = [[ExchangeRecordItem alloc] initWithUserID:exchangeInfo.telmember_id
                                                                 ExchangeInfo:content
                                                                    timeValue:exchangeTime];
        item.cellHeight = 26.f;
        [section addItem:item];
    }
    
    [self.tableViewMager removeAllSections];
    [self.tableViewMager addSection:section];
    
    [self.listView reloadData];
}

@end
