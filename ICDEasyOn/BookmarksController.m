//
//  BookmarksController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 18/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "BookmarksController.h"

@interface BookmarksController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation BookmarksController

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
	// Do any additional setup after loading the view.
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

- (IBAction)showMenu:(id)sender {
      [self.sideMenuViewController presentMenuViewController];
}
@end
