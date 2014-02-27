//
//  MasterViewController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 06/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "MasterViewController.h"
#import "iOSRequest.h"
#import "DetailViewController.h"
#import "AdvancedSearchViewController.h"
#import "CodeICD.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "History.h"
#import "DataCenter.h"

@interface MasterViewController () {
  
   
}
@end

@implementation MasterViewController

@synthesize table,_searchBar,_objects,fromHistory,text;




- (void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(!fromHistory){
    [defaults setBool:YES forKey:@"titleChecked"];
    [defaults setBool:NO forKey:@"definitionChecked"];
    [defaults setBool:NO forKey:@"inclusionChecked"];
    [defaults setBool:NO forKey:@"exclusionChecked"];
    [defaults setBool:NO forKey:@"noteChecked"];
    [defaults setBool:NO forKey:@"codingChecked"];
    [defaults synchronize];
    }
    else{
      
        [self searchBarTextDidBeginEditing:_searchBar];
        [self searchBarSearchButtonClicked:_searchBar];
    
    }
        
   
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (fromHistory) {
       searchBar.text = text;
    }
    
}

-(void)fetchAddress:(NSString *)address
{
    NSLog(@"Loading Address: %@",address);
    NSLog(@"Fetching...");
    
    [self setStart:[NSDate date]];
    
    [SVProgressHUD showWithStatus:@"Searching for keyword..."];
    
    
     [iOSRequest requestToPath:address 
                 onCompletion:^(NSString *result, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if(error){
                             [self stopFetching:@"Failed to Fetch!"];
                             NSLog(@"%@",error);
                         }else{
                             [self stopFetching:result];
                             
                         }
                     });
                     
                 }];
    
    
}



-(void)stopFetching:(NSString *)result
{
  
     
    NSTimeInterval time = [self.start timeIntervalSinceNow];
    float a = fabsf(time);
    NSString *timeLabel = [NSString stringWithFormat:@"%@%.2f%@",@" codes in ",a , @" seconds"];
    
     
    _objects = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrayCH =[[NSMutableArray alloc] init];
    NSMutableArray *arrayBL =[[NSMutableArray alloc] init];
    NSMutableArray *arrayCA =[[NSMutableArray alloc] init];
  
   AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
   
    int numberOfCodes=0;
    
    for (CodeICD *object in [app.listArray copy] ){
        
        if([object.Type isEqualToString:@"CH"]){
            
            [arrayCH addObject:object];
            numberOfCodes++;
        }
        else if([object.Type isEqualToString:@"BL"]){
           
            [arrayBL addObject:object];
            numberOfCodes++;
        }
        else if([object.Type isEqualToString:@"CA"]){
           
            [arrayCA addObject:object];
            numberOfCodes++;
        }
        
        
    }
    
    NSDictionary *dictCH = [NSDictionary dictionaryWithObject:arrayCH forKey:@"data"];
    [_objects addObject:dictCH];
    
    NSDictionary *dictBL = [NSDictionary dictionaryWithObject:arrayBL forKey:@"data"];
    [_objects addObject:dictBL];
    
    NSDictionary *dictCA = [NSDictionary dictionaryWithObject:arrayCA forKey:@"data"];
    [_objects addObject:dictCA];
    
    
    [table reloadData];
    
    [SVProgressHUD dismiss];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Returned Information" message:[NSString stringWithFormat:@"%i%@", numberOfCodes,timeLabel] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    
    [alert show];
    
    NSLog(@"Done Fetching!");
    
    
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_objects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [_objects objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
    {
        return @"Chapters";
    }
    else if(section == 1)
    {
        return @"Blocks";
    }
    else
        return @"Categories";
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
    CodeICD *codeICD = [array objectAtIndex:indexPath.row];
    
    switch (indexPath.section) {
        case 0:
             cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"Chapter ",codeICD.Code];
            
            break;
            
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"Block ",codeICD.Code];

            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"Category ",codeICD.Code];

            break;
        
    }
    
   cell.detailTextLabel.text = codeICD.Preferred;
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *dictionary = [_objects objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
         CodeICD *code = array[indexPath.row];
        
        DetailViewController *d = [segue destinationViewController];
        d.codeICD = code;
       
        d.title = [[[self.table cellForRowAtIndexPath:indexPath] textLabel ]text];
        

    }
    
}

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (fromHistory) {
        [self fetchAddress:_searchBar.text];
        [self.view endEditing:YES];
        fromHistory = !fromHistory;
        
    }else{
        [self fetchAddress:_searchBar.text];
        [self.view endEditing:YES];
        [self addCodeToHistory:_searchBar.text];
        [[DataCenter sharedInstance] addKeyword:_searchBar.text];
    }

}


-(void)addCodeToHistory:(NSString *) keyword{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *titleS = ([defaults boolForKey:@"titleChecked"]) ? @"YES" : @"NO";
    NSString *definitionS = ([defaults boolForKey:@"definitionChecked"]) ? @"YES" : @"NO";
    NSString *noteS = ([defaults boolForKey:@"noteChecked"]) ? @"YES" : @"NO";
    NSString *inclusionS = ([defaults boolForKey:@"inclusionChecked"]) ? @"YES" : @"NO";
    NSString *exclusionS = ([defaults boolForKey:@"exclusionChecked"]) ? @"YES" : @"NO";
    NSString *codingS = ([defaults boolForKey:@"codingChecked"]) ? @"YES" : @"NO";
    
    NSArray *array = [NSArray arrayWithObjects:titleS,definitionS,noteS,inclusionS,exclusionS,codingS, nil];
    NSDictionary *dictio = [NSDictionary dictionaryWithObject:array forKey:@"optionsArray"];
    
    History *history = [[History alloc] initWithKeyword:keyword andDate:[NSDate date] andOptions:dictio];
    
    [app.historyCodes addObject:history];
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:app.historyCodes] forKey:@"historyCodes"];
    [defaults synchronize];
    
    
}
@end
