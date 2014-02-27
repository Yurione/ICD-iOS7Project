//
//  DataPieChart.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 26/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "DataPieChart.h"

@implementation DataPieChart
@synthesize keyword,value;


-(id)initWithKeyword:(NSString*) key andValue:(NSNumber *) number{
    self = [super init];
    if (self) {
        self.keyword = key;
        self.value = number;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.keyword forKey:@"keyword"];
    [aCoder encodeObject:self.value forKey:@"value"];
   
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.keyword = [aDecoder decodeObjectForKey:@"keyword"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
     
    }
    return self;
}

@end
