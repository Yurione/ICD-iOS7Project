//
//  BarGraphViewController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 28/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "BarGraphViewController.h"
#import "DataCenter.h"
#import "CPDConstants.h"
@interface BarGraphViewController ()

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTBarPlot *aaplPlot;

@property (nonatomic, strong) CPTPlotSpaceAnnotation *priceAnnotation;



-(void)initPlot;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
-(void)changeTheme;
@end

@implementation BarGraphViewController
@synthesize defaults;

CGFloat const CPDBarWidth = 0.25f;
CGFloat const CPDBarInitialX = 0.25f;

@synthesize hostView    = hostView_;
@synthesize selectedTheme;



-(void)viewDidLoad {
    [super viewDidLoad];
     defaults = [NSUserDefaults standardUserDefaults];
   
    [self initPlot];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
 
    return [[[DataCenter sharedInstance] topBG] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if ((fieldEnum == CPTBarPlotFieldBarTip) && (index < [[[DataCenter sharedInstance] topBG] count])) {
        if ([plot.identifier isEqual:@"bgID"]) {
            DataPieChart *data =[[[DataCenter sharedInstance] topBG] objectAtIndex:index];
            return data.value;
        }
    }
    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    
    // 1 - Is the plot hidden?
  /*  if (plot.isHidden == YES) {
        return;
    }*/
    // 2 - Create style, if necessary
    static CPTMutableTextStyle *style = nil;
    if (!style) {
        style = [CPTMutableTextStyle textStyle];
        style.color= [CPTColor yellowColor];
        style.fontSize = 16.0f;
        style.fontName = @"Helvetica-Bold";
    }
    // 3 - Create annotation, if necessary
    NSNumber *price = [self numberForPlot:plot field:CPTBarPlotFieldBarTip recordIndex:index];
    if (!self.priceAnnotation) {
        NSNumber *x = [NSNumber numberWithInt:0];
        NSNumber *y = [NSNumber numberWithInt:0];
        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
        self.priceAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
    }
    // 4 - Create number formatter, if needed
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:2];
    }
    // 5 - Create text layer for annotation
    NSString *priceValue = [formatter stringFromNumber:price];
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:priceValue style:style];
    self.priceAnnotation.contentLayer = textLayer;
    // 6 - Get plot index based on identifier
    NSInteger plotIndex = 0;
    if ([plot.identifier isEqual:@"bgID"] == YES) {
        plotIndex = 0;
    }
    // 7 - Get the anchor point for annotation
    CGFloat x = index + CPDBarInitialX + (plotIndex * CPDBarWidth);
    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    CGFloat y = [price floatValue] + 1.0f;
    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    self.priceAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    // 8 - Add the annotation 
    [plot.graph.plotAreaFrame.plotArea addAnnotation:self.priceAnnotation];
}

#pragma mark - Chart behavior
-(void)initPlot {
    self.hostView.allowPinchScaling = NO;
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureGraph {
    
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView.hostedGraph = graph;
    // 2 - Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:[defaults objectForKey:@"BarTheme"]]];
    graph.paddingBottom = 30.0f;
    graph.paddingLeft  = 30.0f;
    graph.paddingTop    = -1.0f;
    graph.paddingRight  = -5.0f;
    // 3 - Set up styles
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    // 4 - Set up title
    NSString *title = @"Five Popular Chapters";
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -16.0f);
    // 5 - Set up plot space
    CGFloat xMin = 0.0f;
    CGFloat xMax = [[[DataCenter sharedInstance] topBG] count];
    CGFloat yMin = 0.0f;
    CGFloat yMax = [[[[DataCenter sharedInstance] maxBarValue] value] integerValue] + 10;     CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
}

-(void)configurePlots {
    
    // 1 - Set up the three plots
    self.aaplPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    self.aaplPlot.identifier = @"bgID";
    
    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.5;
    // 3 - Add plots to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    CGFloat barX = CPDBarInitialX;
    NSArray *plots = [NSArray arrayWithObjects:self.aaplPlot,nil];
    for (CPTBarPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
        plot.barOffset = CPTDecimalFromDouble(barX);
        plot.lineStyle = barLineStyle;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        barX += CPDBarWidth;
    }
    
}

-(void)configureAxes {
    
    // 1 - Configure styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1];
    // 2 - Get the graph's axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    // 3 - Configure the x-axis
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.title = @"Chapters";
    axisSet.xAxis.titleTextStyle = axisTitleStyle;
    axisSet.xAxis.titleOffset = 15.0f;
    axisSet.xAxis.axisLineStyle = axisLineStyle;
    CGFloat dateCount = [[[DataCenter sharedInstance] topBG] count];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
     NSInteger i = 0;
     for (DataPieChart *date in [[DataCenter sharedInstance] topBG]) {
         
         CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date.keyword  textStyle: axisSet.xAxis.labelTextStyle];
         CGFloat location = i++;
         label.tickLocation = CPTDecimalFromCGFloat(location);
         label.offset =  axisSet.xAxis.majorTickLength;
         if (label) {
             [xLabels addObject:label];
             [xLocations addObject:[NSNumber numberWithFloat:location]];
         }
     }
    
    axisSet.xAxis.axisLabels = xLabels;
    
    // 4 - Configure the y-axis
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.yAxis.title = @"Returned in search";
    axisSet.yAxis.titleTextStyle = axisTitleStyle;
    axisSet.yAxis.titleOffset = 5.0f;
    axisSet.yAxis.axisLineStyle = axisLineStyle;
}

-(void)changeTheme{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Apply a Theme" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:CPDThemeNameDarkGradient, CPDThemeNamePlainBlack, CPDThemeNameSlate, CPDThemeNameStocks, nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
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
	} else if ([title isEqualToString:CPDThemeNameSlate] == YES) {
		themeName = kCPTSlateTheme;
	} else if ([title isEqualToString:CPDThemeNameStocks] == YES) {
		themeName = kCPTStocksTheme;
	}
	// 3 - Apply new theme
    [defaults setObject:themeName forKey:@"BarTheme"];
    [defaults synchronize];
  
    [self initPlot];
}



@end
