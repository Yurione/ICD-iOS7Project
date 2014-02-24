//
//  BaseElement.m
//  ICD_iOSPrototype
//
//  Created by Filipe Ferreira on 12/27/13.
//  Copyright (c) 2013 Filipe Ferreira. All rights reserved.
//

#import "CodeICD.h"

@implementation CodeICD
@synthesize Id,Code,Preferred,Type,HtmlResult,Superclass;


-(id)initWithId:(NSString *)identi andCode:(NSString *)code andPreferred:(NSString *)preferred andType:(NSString *)type andHtml:(NSString *)html
         andSuper:(NSString *)superclass
{
    self = [super init];
    if(self){
        Id = identi;
        Code = code;
        Preferred = preferred;
        Type = type;
        HtmlResult = html;
        Superclass = superclass;
        
        
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.Id forKey:@"Id"];
    [aCoder encodeObject:self.Code forKey:@"Code"];
    [aCoder encodeObject:self.Preferred forKey:@"Preferred"];
    [aCoder encodeObject:self.Type forKey:@"Type"];
    [aCoder encodeObject:self.HtmlResult forKey:@"HtmlResult"];
    [aCoder encodeObject:self.Superclass forKey:@"Superclass"];
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.Id = [aDecoder decodeObjectForKey:@"Id"];
        self.Code = [aDecoder decodeObjectForKey:@"Code"];
        self.Preferred = [aDecoder decodeObjectForKey:@"Preferred"];
        self.Type = [aDecoder decodeObjectForKey:@"Type"];
        self.HtmlResult = [aDecoder decodeObjectForKey:@"HtmlResult"];
        self.Superclass = [aDecoder decodeObjectForKey:@"Superclass"];
    }
    
    return self;
}
-(BOOL)isEqual:(CodeICD *)object{
    
    if ([object.Code isEqualToString:self.Code]) {
        return YES;
    }
    else
        return NO;
    
}
@end
