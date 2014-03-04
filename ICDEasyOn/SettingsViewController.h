//
//  SettingsViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 28/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "AppDelegate.h"
@interface SettingsViewController : UITableViewController<UIAlertViewDelegate>{
    
    NSUserDefaults *defaults;
    AppDelegate *app;
}
@property (nonatomic,strong)NSUserDefaults *defaults;

- (IBAction)showMenu:(id)sender;

@end
