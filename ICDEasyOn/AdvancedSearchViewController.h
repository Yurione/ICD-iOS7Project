//
//  SettingsController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 16/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedSearchViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *table;
- (IBAction)switchTitle:(id)sender;
- (IBAction)switchDefinition:(id)sender;
- (IBAction)switchInclusion:(id)sender;
- (IBAction)switchExclusion:(id)sender;
- (IBAction)switchNote:(id)sender;
- (IBAction)switchCoding:(id)sender;

@end
