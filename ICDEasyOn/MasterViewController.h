//
//  MasterViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 06/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "AppDelegate.h"
@interface MasterViewController : UITableViewController{
    BOOL fromHistory;
    NSString *text;
    AppDelegate *app;

}

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UISearchBar *_searchBar;
@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSMutableArray *_objects;
@property (assign, nonatomic) BOOL fromHistory;
@property (strong, nonatomic) NSString *text;

- (IBAction)showMenu:(id)sender;

@end
