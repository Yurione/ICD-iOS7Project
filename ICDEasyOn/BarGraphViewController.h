//
//  BarGraphViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 28/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
@interface BarGraphViewController : UIViewController<CPTBarPlotDataSource, CPTBarPlotDelegate,UIActionSheetDelegate>{
    
     NSUserDefaults *defaults;
}
@property (nonatomic,strong)NSUserDefaults *defaults;
@property (nonatomic, strong) CPTTheme *selectedTheme;

-(void)changeTheme;

@end
