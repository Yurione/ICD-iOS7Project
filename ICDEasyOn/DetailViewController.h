//
//  DetailViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 06/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeICD.h"

@interface DetailViewController : UIViewController{
    NSMutableArray *arrayBookmarks;
    CodeICD *codeICD;
}


- (IBAction)starClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *star;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) CodeICD *codeICD;
@property (assign) BOOL inBookmarks;
@property (nonatomic,strong) NSMutableArray *arrayBookmarks;
@end
