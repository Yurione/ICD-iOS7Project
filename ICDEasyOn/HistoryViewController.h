//
//  HistoryViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 26/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "AppDelegate.h"

@interface HistoryViewController : UITableViewController<UIAlertViewDelegate>{
    
    AppDelegate *app;
}

@property (strong, nonatomic) NSMutableArray *_objects;

@property (strong, nonatomic) IBOutlet UITableView *table;
- (IBAction)showMenu:(id)sender;
- (IBAction)eraseHistory:(id)sender;

@end
