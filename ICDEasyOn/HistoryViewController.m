//
//  HistoryViewController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 26/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "History.h"
#import "MasterViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController
@synthesize _objects,table;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _objects = [[NSMutableArray alloc] init];
    
    [self analyzeHistory];
    
    
}

- (void)analyzeHistory
{
     AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *arrayToday =[[NSMutableArray alloc] init];
    NSMutableArray *arrayYesterday =[[NSMutableArray alloc] init];
    NSMutableArray *arrayLastWeek =[[NSMutableArray alloc] init];
    NSMutableArray *arrayOlders =[[NSMutableArray alloc] init];
    
    NSDateComponents *componentsNow = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    int thisYear = [componentsNow year];
    int thisMonth = [componentsNow month];
    
    
    NSCalendar *gregorian =
    [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int thisDay =
    [gregorian ordinalityOfUnit:NSDayCalendarUnit
                         inUnit:NSYearCalendarUnit forDate:[NSDate date]];
    
    
    for (History *history in app.historyCodes) {
        
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:history.date];
        
        int historyYear = [components year];
        int historyMonth = [components month];
        int historyDay =
        [gregorian ordinalityOfUnit:NSDayCalendarUnit
                             inUnit:NSYearCalendarUnit forDate:[NSDate date]];
        
        if (historyYear == thisYear) {
            
            if(historyDay == thisDay){
                [arrayToday addObject:history];
            }
            else if (historyDay == (thisDay - 1)){
                [arrayYesterday addObject:history];
            }
            else if (historyDay >= (thisDay - 7)){
                [arrayLastWeek addObject:history];
            }
            else{
                [arrayOlders addObject:history];
            }
        }
        else if(historyYear == (thisYear - 1)){
            
            if((historyMonth == 12) && (thisMonth == 1)){
                
                if ((historyDay == 31) && (thisDay == 1)) {
                    [arrayYesterday addObject:history];
                }
                else if (((31 - historyDay) + thisDay) <= 7){
                    [arrayLastWeek addObject:history];
                }
                else{
                    [arrayOlders addObject:history];
                }
            }
            
        }
    }
    
    NSDictionary *dictT = [NSDictionary dictionaryWithObject:arrayToday forKey:@"data"];
    [_objects addObject:dictT];
    
    NSDictionary *dictY = [NSDictionary dictionaryWithObject:arrayYesterday forKey:@"data"];
    [_objects addObject:dictY];
    
    NSDictionary *dictL = [NSDictionary dictionaryWithObject:arrayLastWeek forKey:@"data"];
    [_objects addObject:dictL];
    
    NSDictionary *dictO = [NSDictionary dictionaryWithObject:arrayOlders forKey:@"data"];
    [_objects addObject:dictO];
    
  
    // [table reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [_objects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSDictionary *dictionary = [_objects objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
    {
        return @"Today";
    }
    else if(section == 1)
    {
        return @"Yesterday";
    }
    else if(section == 2){
        return @"Last Week";
    }
    else{
        return @"Older records";
    }
        
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dictionary = [_objects objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    History *history = [array objectAtIndex:indexPath.row];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 [dateFormatter stringFromDate:history.date]];
    
    cell.textLabel.text = history.keyword;
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (IBAction)showMenu:(id)sender {
    
      [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)eraseHistory:(id)sender {
    
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Clear history"
                                                      message:@"Do you want to continue?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles: @"Yes", nil];
    [myAlert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];

        app.historyCodes = [[NSMutableArray alloc] init];
        
        _objects = [[NSMutableArray alloc] init];
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:app.historyCodes] forKey:@"historyCodes"];
        [defaults synchronize];
        
        [table reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([[segue identifier] isEqualToString:@"showSearch"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *dictionary = [_objects objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        History *history = array[indexPath.row];
        
      
       MasterViewController *master = [segue destinationViewController];
        master.fromHistory = YES;
        master.text = history.keyword;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictio =[NSDictionary dictionaryWithDictionary:history.options];
        NSArray *ar = [dictio objectForKey:@"optionsArray"];
        
        NSString *titleS = [ar objectAtIndex:0];
        NSString *definitionS = [ar objectAtIndex:1];
        NSString *noteS = [ar objectAtIndex:2];
        NSString *inclusionS = [ar objectAtIndex:3];
        NSString *exclusionS = [ar objectAtIndex:4];
        NSString *codingS = [ar objectAtIndex:5];
        
        [defaults setObject:titleS forKey:@"titleChecked"];
         [defaults setObject:definitionS forKey:@"definitionChecked"];
         [defaults setObject:noteS forKey:@"noteChecked"];
         [defaults setObject:inclusionS forKey:@"inclusionChecked"];
         [defaults setObject:exclusionS forKey:@"exclusionChecked"];
         [defaults setObject:codingS forKey:@"codingChecked"];
        
        
        [defaults synchronize];

    }
    
}

@end
