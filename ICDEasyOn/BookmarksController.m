//
//  BookmarksController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 18/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "BookmarksController.h"
#import "GDataParser.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface BookmarksController ()

@end

@implementation BookmarksController
@synthesize table,menuItems;

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
	// Do any additional setup after loading the view.
     AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    menuItems = app.bookmarkCodes;
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    CodeICD *cellValue = [menuItems objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue.Preferred;
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([[segue identifier] isEqualToString:@"showDetai"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CodeICD *code = [menuItems objectAtIndex:indexPath.row];
        DetailViewController *d = [segue destinationViewController];
        d.codeICD = code;
    
        d.title = [[[self.table cellForRowAtIndexPath:indexPath] textLabel ]text];
        
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (IBAction)showMenu:(id)sender {
      [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)bookmarksActivity:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"Import",@"Export", nil];
   
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionsheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"%@",@"Import");
            break;
            
        case 1:
             NSLog(@"%@",@"Export");
            break;
    }
}

@end
