//
//  PieChartViewController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 26/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "PieChartViewController.h"
#import "DataCenter.h"
#import "DataPieChart.h"
#import "CPDConstants.h"
@interface PieChartViewController ()

@end

@implementation PieChartViewController
@synthesize hostView = hostView_;
@synthesize defaults;

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // The plot is initialized here, since the view bounds have not transformed for landscape till now
    defaults = [NSUserDefaults standardUserDefaults];
    [self initPlot];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    [self initPlot];

}
#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
  
  
    return [[[DataCenter sharedInstance] topPC] count];

   
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if (CPTPieChartFieldSliceWidth == fieldEnum)
    {
       
       DataPieChart *dPC = [[[DataCenter sharedInstance] topPC] objectAtIndex:index];
        return dPC.value;
    }
    return [NSDecimalNumber zero];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
   
    // 1 - Define label text style
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText) {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    // 2 - Calculate portfolio total value
    NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:[[DataCenter sharedInstance] countAllTimes]] decimalValue]];
    // 3 - Calculate percentage value
    
    DataPieChart *dataPC = [[[DataCenter sharedInstance] topPC] objectAtIndex:index];
    NSNumber *value = dataPC.value;
    NSDecimalNumber *valueD = [NSDecimalNumber decimalNumberWithDecimal:[value decimalValue]];
    NSDecimalNumber *percent = [valueD decimalNumberByDividingBy:sum];
    // 4 - Set up display label
    
    NSString *labelValue = [NSString stringWithFormat:@"%@ - (%0.1f %%)", [value stringValue],([percent floatValue] * 100.0f)];
    // 5 - Create and return layer with label text
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    DataPieChart *dataPC =  [[[DataCenter sharedInstance] topPC] objectAtIndex:index];
    return dataPC.keyword;
    
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost {
    
    // 1 - Set up view frame
    CGRect parentRect = self.view.bounds;
    CGSize toolbarSize = self.navigationController.navigationBar.bounds.size;
    parentRect = CGRectMake(parentRect.origin.x,
                            (parentRect.origin.y + toolbarSize.height),
                            parentRect.size.width,
                            (parentRect.size.height - toolbarSize.height));
    


    // 2 - Create host view
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
    
}

-(void)configureGraph {
    
    // 1 - Create and initialize graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    // 3 - Configure title
    NSString *title = @"Four Popular Keywords";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    // 4 - Set theme
    self.selectedTheme = [CPTTheme themeNamed:[defaults objectForKey:@"PieTheme"]];
    [graph applyTheme:self.selectedTheme];
}

-(void)configureChart {
    
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.hostView.bounds.size.height * 0.7) / 4;
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    // 4 - Add chart to graph    
    [graph addPlot:pieChart];
}

-(void)configureLegend {
    
    // 1 - Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    // 3 - Configure legend
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    // 4 - Add legend to graph
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorBottomRight;
    CGFloat legendPadding = -(self.view.bounds.size.width / 8);
    graph.legendDisplacement = CGPointMake(legendPadding, 0.0);
}

-(void)changeTheme{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Apply a Theme" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:CPDThemeNameDarkGradient, CPDThemeNamePlainBlack, CPDThemeNamePlainWhite, CPDThemeNameSlate, CPDThemeNameStocks, nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        //Do nothing
    }
    else{
        
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
	// 3 - Apply new theme
    
    [defaults setObject:themeName forKey:@"PieTheme"];
    [defaults synchronize];
	[self.hostView.hostedGraph applyTheme:[CPTTheme themeNamed:themeName]];
    }
}

@end
