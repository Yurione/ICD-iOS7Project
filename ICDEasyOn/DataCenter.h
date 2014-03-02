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
    NSMutableArray *topPC;
    NSMutableArray *arrayResultCodes;
}

@property (nonatomic,strong) NSMutableArray *arrayDataPC;
@property (nonatomic,strong) NSMutableArray *arrayResultCodes;
@property (nonatomic,strong) NSMutableArray *topPC;

+ (DataCenter *)sharedInstance;
-(void)addKeyword:(NSString *) keyword;
-(void)addNumberOfCodes:(int ) number;
-(int)countAllTimes;
-(CGFloat)maxResultCode;
-(void)getTop4Keyword;
@end
