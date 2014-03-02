//
//  StatisticsViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 26/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "PieChartViewController.h"
#import "ScatterPlotViewController.h"
@interface StatisticsViewController : UITabBarController<UITabBarControllerDelegate>{
    UIViewController *viewC;
   
}

@property (nonatomic,strong) UIViewController *viewC;


- (IBAction)showMenu:(id)sender;
- (IBAction)changeTheme:(id)sender;


@end
