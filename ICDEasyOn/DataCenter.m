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
@synthesize arrayDataPC,arrayResultCodes,topPC;

-(id)init{
    self = [super self];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"dataPC"];
        
        arrayDataPC = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        data = [defaults objectForKey:@"arrayResultCodes"];
        arrayResultCodes=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        data = [defaults objectForKey:@"topPC"];
        topPC=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        

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
    
    [self getTop4Keyword];
}

-(void)getTop4Keyword{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [defaults objectForKey:@"topPC"];
    
   topPC = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  
    if(topPC == nil){
        topPC =[[NSMutableArray alloc] init];
    }
    for (DataPieChart *dataPC in arrayDataPC)
    {
        
        if (topPC.count < 4)
        {
            [topPC addObject:dataPC];
        }
        else
        {
            DataPieChart *minValueObject= [[DataPieChart alloc] initWithKeyword:@" " andValue:[[NSNumber alloc] initWithInteger:20000]];
            BOOL alreadyOn = NO;
            for (DataPieChart *dPC in topPC)
            {
                if ([dataPC.keyword isEqualToString:dPC.keyword]) {
                    alreadyOn = YES;
                    break;
                }
                else if ([dPC.value integerValue] < [minValueObject.value integerValue])
                {
                    minValueObject = dPC;
                }
            }
            if (alreadyOn) {
                continue;
            }
            else if([dataPC.value integerValue] > [minValueObject.value integerValue])
            {
                [topPC removeObject:minValueObject];
                [topPC addObject:dataPC];
            }
        }
    }
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:topPC] forKey:@"topPC"];
    [defaults synchronize];
}
-(void)addNumberOfCodes:(int ) number{
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"arrayResultCodes"];
    arrayResultCodes = [NSKeyedUnarchiver unarchiveObjectWithData:data];

  
    if (arrayResultCodes==nil) {
        arrayResultCodes = [[NSMutableArray alloc] init];
    }
    
    if ([arrayResultCodes count]< 10) {
        [arrayResultCodes addObject:[NSNumber numberWithInt:number]];
    }
    else
    {
        [arrayResultCodes removeObjectAtIndex:0];
        [arrayResultCodes addObject:[NSNumber numberWithInt:number]];
        
    }
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:arrayResultCodes] forKey:@"arrayResultCodes"];
    [defaults synchronize];
}

-(CGFloat )maxResultCode{
    NSNumber *max = [[NSNumber alloc] initWithInt:0];
    
    for (NSNumber *number in arrayResultCodes) {
        
        if([number compare:max] == NSOrderedDescending){
            max=number;            
        }
    }
    return [max floatValue];
}
@end
