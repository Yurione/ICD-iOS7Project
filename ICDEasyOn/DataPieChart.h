//
//  DataPieChart.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 26/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPieChart : NSObject<NSCoding>{
    NSString *keyword;
    NSNumber *value;
   }
@property (nonatomic,strong) NSString *keyword;
@property (nonatomic,strong)  NSNumber *value;

-(id)initWithKeyword:(NSString*) key andValue:(NSNumber *) number;

@end
