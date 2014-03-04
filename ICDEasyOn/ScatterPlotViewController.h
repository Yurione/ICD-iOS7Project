//
//  ScatterPlotViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 28/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
@interface ScatterPlotViewController : UIViewController<CPTPlotDataSource,UIActionSheetDelegate>{
     NSUserDefaults *defaults;
}

@property (nonatomic,strong)NSUserDefaults *defaults;
@property (nonatomic, strong) CPTGraphHostingView *hostView;


-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)changeTheme;

@end
