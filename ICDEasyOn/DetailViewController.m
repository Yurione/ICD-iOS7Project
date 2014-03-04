//
//  DetailViewController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 06/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize webview,codeICD,star,inBookmarks,arrayBookmarks,app;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [webview loadHTMLString:codeICD.HtmlResult baseURL:nil];

     app = [[UIApplication sharedApplication] delegate];
    arrayBookmarks= app.bookmarkCodes;
    if ([arrayBookmarks containsObject:codeICD]) {
        inBookmarks=YES;
        [star setImage:[UIImage imageNamed:@"star-32.png"]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (IBAction)starClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (inBookmarks) {
        [star setImage:[UIImage imageNamed:@"outline_star-256.png"]];
        inBookmarks=!inBookmarks;
        
         [app.bookmarkCodes removeObject:codeICD];
        
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:app.bookmarkCodes] forKey:@"bookmarkCodes"];
        [defaults synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bookmarks" message:@"Code deleted from bookmarks with success!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        
        [alert show];
    }
    else{
        int bookmarkCodes =[app.bookmarkCodes count];
        int settingsBookmarks = [[defaults objectForKey:@"codesToStore"] integerValue];
        if (bookmarkCodes == settingsBookmarks) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bookmarks" message:@"You have reached the maximum number of codes storage! Go to Settings to change your limit number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            
            [alert show];
        }
        else{
        
        
        [star setImage:[UIImage imageNamed:@"star-32.png"]];
        inBookmarks=!inBookmarks;
        
        [app.bookmarkCodes addObject:codeICD];
        
       
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:app.bookmarkCodes] forKey:@"bookmarkCodes"];
        [defaults synchronize];
        
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bookmarks" message:@"Code added to bookmarks with success!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        
        [alert show];
        }
    }
    
    
}
@end
