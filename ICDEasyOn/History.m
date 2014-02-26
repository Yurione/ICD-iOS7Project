//
//  History.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 26/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "History.h"

@implementation History
@synthesize keyword,identifier,date,options;
static int ide=1;
-(id)initWithKeyword:(NSString *) aKeyword andDate:(NSDate *) aDate andOptions:(NSDictionary *) aOptions{
    
    self = [super init];
    if(self){
        self.keyword = aKeyword;
        self.date = aDate;
        self.options = aOptions;
        self.identifier = ide++;
        return self;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.keyword forKey:@"keyword"];
    [aCoder encodeObject:self.date forKey:@"date"];    
    [aCoder encodeObject:self.options forKey:@"options"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.identifier] forKey:@"identifier"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.keyword = [aDecoder decodeObjectForKey:@"keyword"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.options = [aDecoder decodeObjectForKey:@"options"];
        self.identifier = [[aDecoder decodeObjectForKey:@"identifier"] integerValue];
    }
    return self;
}

@end
