//
//  BookmarksController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 18/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@interface BookmarksController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSArray *menuItems;

- (IBAction)showMenu:(id)sender;
- (IBAction)bookmarksActivity:(id)sender;

@end
