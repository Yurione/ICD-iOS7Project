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
#import "CodeICD.h"
#import "AppDelegate.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    __weak IBOutlet UISearchBar *searchBar;
}
@end

@implementation MasterViewController

@synthesize table;


- (IBAction)showMenu{
    [self.sideMenuViewController presentMenuViewController];
}




-(void)fetchAddress:(NSString *)address
{
    NSLog(@"Loading Address: %@",address);
    
     [iOSRequest requestToPath:address titleC:true definitionC:false noteC:false
                   inclusionC:false exclusionC:false codingC:false
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


- (IBAction)fetchKeyword:(id)sender
{
    
    [self startFetching];
    [self fetchAddress:searchBar.text];
    [self.view endEditing:YES];
}

-(void)startFetching
{
    NSLog(@"Fetching...");
    //[self hideAll];
    //[self.addressField resignFirstResponder];
    //[self.loading startAnimating];
    //[self setStart:[NSDate date]];
    //NSLog(@"%@",self.start);
    self.fetchButton.enabled = NO;
    
}

-(void)stopFetching:(NSString *)result
{
    
   /* NSTimeInterval time = [self.start timeIntervalSinceNow];
    float a = fabsf(time);
    timeLabel.text = [NSString stringWithFormat:@"%@%.2f%@",@"Time elapsed: ",a , @" seconds"];
    NSMutableArray *tData = [[NSMutableArray alloc] init];
    
    */
   
    _objects = [[NSMutableArray alloc] init];
    
    
   AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    NSString *inToast=@"";
    
    for (CodeICD *object in [app.listArray copy] ){
        
        if([object.Type isEqualToString:@"CH"]){
            inToast=@"Chapter ";
            [_objects addObject:[NSString stringWithFormat:@"%@%@",inToast,object.Code]];
        }else if([object.Type isEqualToString:@"BL"]){
            inToast=@"Block ";
            [_objects addObject:[NSString stringWithFormat:@"%@%@",inToast,object.Code]];
        }
        else if([object.Type isEqualToString:@"CA"]){
            inToast=@"Category ";
            [_objects addObject:[NSString stringWithFormat:@"%@%@",inToast,object.Code]];
        }
        
        
    }
    
    
    [table reloadData];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Returned codes" message:[NSString stringWithFormat:@"%i", _objects.count] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [alert show];
    
    
    NSLog(@"Done Fetching!");
    
    //[self.view makeToast:[NSString stringWithFormat:@"%@%i",@"Returned CodesICD: ",[app.listArray count]]];
    //[self.loading stopAnimating];
    self.fetchButton.enabled = YES;
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
      AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CodeICD *code = app.listArray[indexPath.row];
        DetailViewController *d = [segue destinationViewController];
        d.loadHtml = code.HtmlResult;
       
        d.title = [[[self.table cellForRowAtIndexPath:indexPath] textLabel ]text];
        

    }
}


@end
