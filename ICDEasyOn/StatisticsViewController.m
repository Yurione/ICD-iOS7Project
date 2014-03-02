//
//  StatisticsViewController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 26/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "StatisticsViewController.h"
#import "CPDConstants.h"
#import "CorePlot-CocoaTouch.h"
#import "PieChartViewController.h"
#import "ScatterPlotViewController.h"
#import "BarGraphViewController.h"

@interface StatisticsViewController ()

@end

@implementation StatisticsViewController
@synthesize viewC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    viewC = [[self viewControllers] objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender {
    
     [self.sideMenuViewController presentMenuViewController];
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController.tabBarItem.title isEqualToString:@"Pie Chart"])
    {
       
        viewC = viewController;
    }
   else if ([viewController.tabBarItem.title isEqualToString:@"Scatter Plot"])
    {
        viewC = viewController;

    }
    else if ([viewController.tabBarItem.title isEqualToString:@"Bar Graph"])
    {
        viewC = viewController;

    }
    
}

- (IBAction)changeTheme:(id)sender {
    
    if ([viewC isKindOfClass:[PieChartViewController class]]) {
         [(PieChartViewController *) viewC changeTheme];
    }
   else if ([viewC isKindOfClass:[ScatterPlotViewController class]]) {
        [(ScatterPlotViewController *) viewC changeTheme];
    }
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// 1 - Get title of tapped button
	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
	// 2 - Get theme identifier based on user tap
	NSString *themeName = kCPTPlainWhiteTheme;
	if ([title isEqualToString:CPDThemeNameDarkGradient] == YES) {
		themeName = kCPTDarkGradientTheme;
	} else if ([title isEqualToString:CPDThemeNamePlainBlack] == YES) {
		themeName = kCPTPlainBlackTheme;
	} else if ([title isEqualToString:CPDThemeNamePlainWhite] == YES) {
		themeName = kCPTPlainWhiteTheme;
	} else if ([title isEqualToString:CPDThemeNameSlate] == YES) {
		themeName = kCPTSlateTheme;
	} else if ([title isEqualToString:CPDThemeNameStocks] == YES) {
		themeName = kCPTStocksTheme;
	}
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:themeName forKey:@"theme"];
    [defaults synchronize];
}


@end
