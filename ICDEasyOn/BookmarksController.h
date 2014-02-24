//
//  BookmarksController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 18/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@interface BookmarksController : UITableViewController
- (IBAction)showMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSArray *menuItems;
@end
