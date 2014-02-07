//
//  DetailViewController.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 06/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController



@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic,strong) NSString *loadHtml;
@end
