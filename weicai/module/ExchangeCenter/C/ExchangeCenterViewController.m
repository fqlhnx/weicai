//
//  ExchangeCenterViewController.m
//  weicai
//
//  Created by liuhongnian on 14-9-28.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "ExchangeCenterViewController.h"
#import "ExchangeCenterAPI.h"
#import "ServerConfig.h"

#import "RETableViewManager.h"
#import "MarqueeLabel.h"

@interface ExchangeCenterViewController ()

@property(nonatomic,weak)IBOutlet UITextField *aliPayAccount;
@property(nonatomic,weak)IBOutlet UITextField *phoneNum;

@property(nonatomic,weak)IBOutlet UITableView *listView;
@property(nonatomic,strong) RETableViewManager *tableViewManger;

@property(nonatomic,strong)ExchangeCenterAPI *exchangeAPI;

@end

@implementation ExchangeCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"兑换中心";
        
        _exchangeAPI = [[ExchangeCenterAPI alloc] initWithBaseURL:[NSURL URLWithString:ServerURL]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ui actions


@end
