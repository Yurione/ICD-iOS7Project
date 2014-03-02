//
//  PieChartViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 26/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
@interface PieChartViewController : UIViewController<CPTPlotDataSource,UIActionSheetDelegate>

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;

-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)configureChart;
-(void)configureLegend;
-(void)changeTheme;

@end
