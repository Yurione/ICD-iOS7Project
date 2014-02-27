//
//  DataCenter.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 27/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject{
    NSMutableArray *arrayDataPC;
}

@property (nonatomic,strong) NSMutableArray *arrayDataPC;

+ (DataCenter *)sharedInstance;
-(void)addKeyword:(NSString *) keyword;
-(int)countAllTimes;
@end
