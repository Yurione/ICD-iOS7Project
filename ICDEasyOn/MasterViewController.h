//
//  MasterViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 06/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController
- (IBAction)fetchKeyword:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fetchButton;

@property (strong, nonatomic) IBOutlet UITableView *table;

@end
