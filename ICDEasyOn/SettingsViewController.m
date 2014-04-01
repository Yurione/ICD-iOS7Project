//
//  SettingsViewController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 28/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "SettingsViewController.h"
#import "iOSRequest.h"
#import "SVProgressHUD.h"
#import <limits.h>
#import "CPDConstants.h"
@interface SettingsViewController ()
@property (nonatomic,assign) bool testAddress;
@property (nonatomic,assign) bool codesToStore;

@end

@implementation SettingsViewController
@synthesize defaults,testAddress,codesToStore;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    app = [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
   
    
    
    switch (indexPath.row) {
        case 0:
            
            cell.textLabel.text =@"Endpoint Address";
            cell.detailTextLabel.text = [defaults objectForKey:@"endpointAddress"];
            break;
        case 1:
            
            cell.textLabel.text =@"Number of Codes to Store";
            cell.detailTextLabel.text =[defaults objectForKey:@"codesToStore"];
            break;
        case 2:
            
            cell.textLabel.text =@"Restore Factory Settings";
       
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row==0) {
        
        
        testAddress=YES;
        
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Change Endpoint Address" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
        messageAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *txtField = [messageAlert textFieldAtIndex:0];
        txtField.text = [defaults objectForKey:@"endpointAddress"];
        [messageAlert show];
    }
    
   else if (indexPath.row==1) {
       
       codesToStore=YES;
       
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Number of Codes to Store"
                                     message:nil
                                     delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     otherButtonTitles:@"Ok",nil];
       
        messageAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *txtField = [messageAlert textFieldAtIndex:0];
        txtField.keyboardType = UIKeyboardTypeNumberPad;
        [messageAlert show];
    }

   else if (indexPath.row==2) {
       
       [self setFactorySettings];
   }
    
   
}

-(void)validateUserAddress:(UIAlertView *)alertView{
    
    [SVProgressHUD showWithStatus:@"Validating address..."];
    
    [iOSRequest requestPathValidate:[alertView textFieldAtIndex:0].text
                       onCompletion:^(NSString *result, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if([result isEqualToString:@"200"]){
                 [SVProgressHUD dismiss];
                 
                 [defaults setObject:[alertView textFieldAtIndex:0].text forKey:@"endpointAddress"];
                 [defaults synchronize];
                 [self.tableView reloadData];
                 
             }else{
                 
                 [SVProgressHUD dismiss];
                 
                 UIAlertView *messageAlert = [[UIAlertView alloc]
                                              initWithTitle:@"The Address is Not Valid"
                                              message:[NSString stringWithFormat:@"HTTP %@ Error",result]
                                              delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok",nil];
                 
                 [messageAlert show];
                 
             }
         });
         
         
     }];

    
}

-(void)validateCodesToStore:(UIAlertView *)alertView{
    int numberOfCodesToStore =[[alertView textFieldAtIndex:0].text integerValue];
   /* if (numberOfCodesToStore==0) {
        
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Invalid number"
                                     message:[NSString stringWithFormat:@"The number must be higher than %i",numberOfCodesToStore]
                                     delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"Ok",nil];
        
        [messageAlert show];
    }
    */
    
     if (numberOfCodesToStore > INT16_MAX){
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Invalid number"
                                     message:[NSString stringWithFormat:@"The maximum number admitted is the %i",INT16_MAX]
                                     delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"Ok",nil];
        
        [messageAlert show];
    }
    else if ([app.bookmarkCodes count] <= numberOfCodesToStore) {
        
        [defaults setObject:[alertView textFieldAtIndex:0].text forKey:@"codesToStore"];
        [defaults synchronize];
        [self.tableView reloadData];
        
    }
    else{
       
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Invalid number"
                                     message:[NSString stringWithFormat:@"There are %i codes in the bookmarks. Give me a higher or equal value!",[app.bookmarkCodes count]]
                                     delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"Ok",nil];
        
        [messageAlert show];
    }
    
}
-(void)setFactorySettings{
    
    [defaults setObject:ENDPOINT_ADDRESS forKey:@"endpointAddress"];
    [defaults setObject:CODES_TO_STORE forKey:@"codesToStore"];
    [defaults synchronize];
    
    [self.tableView reloadData];
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Factory Settings"
                                 message:@"Default application settings applied with success!"
                                 delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"Ok",nil];
    
    [messageAlert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.cancelButtonIndex == buttonIndex){
        // Do cancel
        
        //[string intvalue]
    }
    else if(testAddress){
        [self validateUserAddress:alertView];
        testAddress=NO;
    }
    else if(codesToStore){
        
        [self validateCodesToStore:alertView];
        codesToStore = NO;
    }
    
}

- (IBAction)showMenu:(id)sender {
    
      [self.sideMenuViewController presentMenuViewController];
}
@end
