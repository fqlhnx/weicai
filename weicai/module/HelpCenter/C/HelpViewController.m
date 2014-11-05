//
//  HelpViewController.m
//  weicai
//
//  Created by liuhongnian on 14-9-28.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "HelpViewController.h"

#import "FTCoreTextView.h"
#import "FTCoreTextStyle.h"

@interface HelpViewController ()

@property (nonatomic,weak)IBOutlet UIScrollView *myScorllView;
@property (nonatomic,strong) FTCoreTextView *coreTextView;

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"帮助中心";
        self.tabBarItem.image = [[UIImage imageNamed:@"item4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"item4Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.coreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.view.frame) - 40, 0)];
    [self.coreTextView setText:[self helpContent]];
    
    FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
    defaultStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16.f];
    defaultStyle.textAlignment = FTCoreTextAlignementJustified;

    [self.coreTextView addStyle:defaultStyle];
    
    [self.myScorllView addSubview:self.coreTextView];
    
}

- (void)viewDidLayoutSubviews
{
    [self.coreTextView fitToSuggestedHeight];
    
    [self.myScorllView setContentSize:CGSizeMake(CGRectGetWidth(self.myScorllView.bounds), CGRectGetHeight(self.coreTextView.frame) + 110.f)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark prive

- (NSString*)helpContent
{
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"helpDoc" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    
}

@end
