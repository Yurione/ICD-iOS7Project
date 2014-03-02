//
//  BookmarksController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 18/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import <MessageUI/MessageUI.h> 
#import "AppDelegate.h"

@interface BookmarksController : UITableViewController <UIActionSheetDelegate,MFMailComposeViewControllerDelegate>{
    
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *menuItems;

- (IBAction)showMenu:(id)sender;
- (IBAction)bookmarksActivity:(id)sender;

@end
