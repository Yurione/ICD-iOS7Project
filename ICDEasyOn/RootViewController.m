//
//  RootViewController.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 07/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "RootViewController.h"
#import "MenuViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard
                                  instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    self.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.delegate = (MenuViewController *)self.menuViewController;
}

@end
