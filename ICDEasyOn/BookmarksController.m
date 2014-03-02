//
//  BookmarksController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 18/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "BookmarksController.h"
#import "GDataParser.h"
#import "DetailViewController.h"

@interface BookmarksController ()

@end

@implementation BookmarksController
@synthesize table,menuItems;

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
    
    app = [[UIApplication sharedApplication] delegate];
    

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    menuItems = [[NSMutableArray alloc]initWithArray:app.bookmarkCodes];
 
  
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    CodeICD *cellValue = [menuItems objectAtIndex:indexPath.row];
    
    if([cellValue.Type isEqualToString:@"CH"]){
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"Chapter ",cellValue.Code];
       
    }
    
    else if([cellValue.Type isEqualToString:@"BL"]){
        
         cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"Block ",cellValue.Code];
        
    }
    
    else{
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"Category ",cellValue.Code];
        
    }
   cell.detailTextLabel.text = cellValue.Preferred;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        [app.bookmarkCodes removeObjectAtIndex:indexPath.row];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:app.bookmarkCodes] forKey:@"bookmarkCodes"];
        [defaults synchronize];
        
        [menuItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([[segue identifier] isEqualToString:@"showDetai"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CodeICD *code = [menuItems objectAtIndex:indexPath.row];
        DetailViewController *d = [segue destinationViewController];
        d.codeICD = code;
    
        d.title = [[[self.table cellForRowAtIndexPath:indexPath] textLabel ]text];
        
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data =[defaults objectForKey:@"bookmarkCodes"];
    NSArray *array =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
   [menuItems setArray:array];
    
    [table reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (IBAction)showMenu:(id)sender {
      [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)bookmarksActivity:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"Import",@"Export", nil];
   
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionsheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"%@",@"Import");
            
            [app.bookmarkCodes setArray:[GDataParser loadFile]];
            [menuItems setArray:[GDataParser loadFile]];
            [table reloadData];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:app.bookmarkCodes] forKey:@"bookmarkCodes"];
            [defaults synchronize];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Import" message:[NSString stringWithFormat:@"Imported %d codes from bookmarks file with success!",menuItems.count] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            
            [alert show];
            
            break;
        }
        case 1:
        {
             NSLog(@"%@",@"Export");
            if ([MFMailComposeViewController canSendMail])
                // The device can send email.
            {
                [self displayMailComposerSheet];
            }
            else
                // The device can not send email.
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Device not configured to send mail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                
                [alert show];
               
            }
            
           
            
            break;
        }
    }
}
- (void)displayMailComposerSheet
{
    //Update the bookmarks xml file
    
    [GDataParser saveBookmarks];
    
    
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"<h1>Learning iOS Programming!</h1>"; // Change the message body to HTML
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
   
    
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    // Attach an xml file to the email
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bookmarks" ofType:@"xml"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [mc addAttachmentData:myData mimeType:@"application/xml" fileName:@"bookmarks"];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}





@end
