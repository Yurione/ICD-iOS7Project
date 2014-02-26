//
//  SettingsController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 16/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "AdvancedSearchViewController.h"

@interface AdvancedSearchViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation AdvancedSearchViewController

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
	_menuItems = @[@"title",@"definition",@"inclusion",@"exclusion",@"note", @"codingHint"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:YES forKey:@"titleChecked"];
    [defaults setBool:NO forKey:@"definitionChecked"];
    [defaults setBool:NO forKey:@"inclusionChecked"];
    [defaults setBool:NO forKey:@"exclusionChecked"];
    [defaults setBool:NO forKey:@"noteChecked"];
    [defaults setBool:NO forKey:@"codingChecked"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}


- (IBAction)switchTitle:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    [defaults setBool:[sender isOn] forKey:@"titleChecked"];
    [defaults synchronize];
   
}

- (IBAction)switchDefinition:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:[sender isOn] forKey:@"definitionChecked"];
    [defaults synchronize];
}

- (IBAction)switchInclusion:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [defaults setBool:[sender isOn] forKey:@"inclusionChecked"];
    [defaults synchronize];
}

- (IBAction)switchExclusion:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [defaults setBool:[sender isOn] forKey:@"exclusionChecked"];
    [defaults synchronize];
}

- (IBAction)switchNote:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [defaults setBool:[sender isOn] forKey:@"noteChecked"];
    [defaults synchronize];
}

- (IBAction)switchCoding:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [defaults setBool:[sender isOn] forKey:@"codingChecked"];
    [defaults synchronize];
}
@end
