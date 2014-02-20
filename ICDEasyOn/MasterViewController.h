//
//  MasterViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 06/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@interface MasterViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UISearchBar *_searchBar;
@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSMutableArray *_objects;


- (IBAction)showMenu:(id)sender;

@end
