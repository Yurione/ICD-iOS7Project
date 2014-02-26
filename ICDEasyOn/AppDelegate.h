//
//  AppDelegate.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 06/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSMutableArray *bookmarkCodes;
    NSMutableArray *historyCodes;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *bookmarkCodes;
@property (strong, nonatomic) NSMutableArray *historyCodes;
@property (strong, nonatomic) NSMutableArray *listArray;

@end
