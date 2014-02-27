//
//  DataCenter.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 27/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "DataCenter.h"
#import "DataPieChart.h"
@implementation DataCenter
@synthesize arrayDataPC;

-(id)init{
    self = [super self];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"dataPC"];
        
        arrayDataPC = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    }
    return self;
}
+ (DataCenter *)sharedInstance
{
    static DataCenter *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}
-(int)countAllTimes{
    int count=0;
      for (DataPieChart *pie in arrayDataPC) {
          count += [pie.value integerValue];
      }
    return count;
}
-(void)addKeyword:(NSString *) keyword {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
     NSData *data = [defaults objectForKey:@"dataPC"];
   
    arrayDataPC = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    bool match=NO;
    for (DataPieChart *pie in arrayDataPC) {
        if([pie.keyword isEqualToString:keyword]){
            int a =pie.value.integerValue;
            a++;
            pie.value =[[NSNumber alloc] initWithInt:a];
            match =YES;
            break;
        }
    }
    
    if (!match) {
        NSNumber *value = [[NSNumber alloc] initWithInt:1];
        DataPieChart *dPC = [[DataPieChart alloc]initWithKeyword:keyword andValue:value];
        
        
        [arrayDataPC addObject:dPC];
    }
   
   
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:arrayDataPC] forKey:@"dataPC"];
    [defaults synchronize];
}

@end
