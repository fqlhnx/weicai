//
//  TaskListViewController.m
//  weicai
//
//  Created by liuhongnian on 14-9-28.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "TaskListViewController.h"

#import "DMOfferWallManager.h"

@interface TaskListViewController ()<UITableViewDelegate,UITableViewDataSource,DMOfferWallManagerDelegate>

@property (nonatomic,weak)IBOutlet UITableView *listView;

@property (nonatomic,strong)DMOfferWallManager *duoMengOfferWall;

@end

@implementation TaskListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"任务中心";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self advertisingPlatformInit];
    
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)advertisingPlatformInit
{
    //duo meng
    _duoMengOfferWall = [[DMOfferWallManager alloc]initWithPublisherID:@"56OJwVSIuN8LXcFUWu"];
    _duoMengOfferWall.delegate = self;
    
    
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *listCell = @"listCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCell];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"icon-120"];
    cell.textLabel.text = @"多盟积分墙";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_duoMengOfferWall presentOfferWallWithViewController:self
                                                     type:eDMOfferWallTypeList];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
