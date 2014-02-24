//
//  DetailViewController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 06/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize webview,codeICD,star,inBookmarks,arrayBookmarks;

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
 /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data =[defaults objectForKey:@"bookmarkArray"];
    NSArray *array =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    arrayBookmarks=[[NSMutableArray alloc] initWithArray:array];
  */
     AppDelegate *app = [[UIApplication sharedApplication] delegate];
    arrayBookmarks= app.bookmarkCodes;
    if ([arrayBookmarks containsObject:codeICD]) {
       
        [star setImage:[UIImage imageNamed:@"star-32.png"]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (IBAction)starClick:(id)sender {
  
    if (inBookmarks) {
        [star setImage:[UIImage imageNamed:@"outline_star-256.png"]];
        inBookmarks=!inBookmarks;
    }
    else{
        [star setImage:[UIImage imageNamed:@"star-32.png"]];
        inBookmarks=!inBookmarks;
    }
    
    
}
@end
