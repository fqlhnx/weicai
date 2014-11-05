//
//  HelpViewController.m
//  weicai
//
//  Created by liuhongnian on 14-9-28.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "HelpViewController.h"

#import "FTCoreTextView.h"

@interface HelpViewController ()

@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong)FTCoreTextView *ftCoreTextView;

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"帮助中心";
        
        [self.tabBarItem setImage:[[UIImage imageNamed:@"item4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"item4Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.ftCoreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectMake(20, 20, 280, 0)];
    [self.ftCoreTextView setText:[self helpContent]];
    [self.ftCoreTextView addStyles:[self coreTextStyle]];
    [self.ftCoreTextView fitToSuggestedHeight];
    
    [self.myScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.myScrollView.frame), CGRectGetHeight(self.ftCoreTextView.frame) + 100.)];
    [self.myScrollView addSubview:self.ftCoreTextView];
    [self.view addSubview:self.myScrollView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark prive
- (NSArray *)coreTextStyle
{
    NSMutableArray *result = [NSMutableArray array];
    
    FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
    defaultStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16.f];
    defaultStyle.textAlignment = FTCoreTextAlignementJustified;
    [result addObject:defaultStyle];

    return result;
}



- (NSString*)helpContent
{
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
}

@end
