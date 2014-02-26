//
//  GDataParser.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 22/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodeICD.h"
@interface GDataParser : NSObject


+ (NSMutableArray *)loadFile;
+ (void)saveBookmarks;

@end
