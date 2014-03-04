//
//  DataCenter.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 27/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "DataCenter.h"
#import "CodeICD.h"
@implementation DataCenter
@synthesize arrayDataPC,arrayResultCodes,topPC,arrayAllChapters,topBG,maxBarValue;

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
        
        data = [defaults objectForKey:@"topBG"];
        topBG=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        data = [defaults objectForKey:@"maxBarValue"];
        maxBarValue = [NSKeyedUnarchiver unarchiveObjectWithData:data];

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
    
    if (match==NO) {
        NSNumber *value = [[NSNumber alloc] initWithInt:1];
        DataPieChart *dPC = [[DataPieChart alloc]initWithKeyword:keyword andValue:value];
        
        
        [arrayDataPC addObject:dPC];
    }
    match = NO;
   
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:arrayDataPC] forKey:@"dataPC"];
    [defaults synchronize];
    
    [self getTop4Keyword];
}

-(void)addChapters:(NSMutableArray *)arrayOfChapters{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [defaults objectForKey:@"dataBG"];
    
    arrayAllChapters = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    bool match=NO;
    for (CodeICD *codeICD in arrayOfChapters) {
       
        for (DataPieChart *dPC in arrayAllChapters) {
            if ([dPC.keyword isEqualToString:codeICD.Code]==YES) {
                int a =dPC.value.integerValue;
                a++;
                dPC.value =[[NSNumber alloc] initWithInt:a];
                match=YES;
                break;
            }
        }
        if (match==NO) {
            NSNumber *value = [[NSNumber alloc] initWithInt:1];
            DataPieChart *dPC = [[DataPieChart alloc]initWithKeyword:codeICD.Code andValue:value];
            
            [arrayAllChapters addObject:dPC];
        
        }
        match = NO;
    
    }
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:arrayAllChapters] forKey:@"dataBG"];
    [defaults synchronize];

    [self getTop5Chapters];
    
}



-(void)getTop4Keyword{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
    topPC =[[NSMutableArray alloc] init];
   
        
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"value"
                                        ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [arrayDataPC
                                 sortedArrayUsingDescriptors:sortDescriptors];
    
    
    
    int count=0,others=0;
    for (DataPieChart *dataPC in sortedEventArray)
    {
        
        if (count < 4)
        {
            [topPC addObject:dataPC];
            count++;
        }
        else
        {
            others += [dataPC.value integerValue];
            
        }
        
    }
    [topPC addObject:[[DataPieChart alloc] initWithKeyword:@"Others"
                                                  andValue:[NSNumber numberWithInt:others]]];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:topPC] forKey:@"topPC"];
    [defaults synchronize];
  
}
-(void)getTop5Chapters{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
    
   
    topBG =[[NSMutableArray alloc] init];
    
    
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"value"
                                        ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [arrayAllChapters
                                 sortedArrayUsingDescriptors:sortDescriptors];
    
    
    
     int count =0;
    for (DataPieChart *dataPC in sortedEventArray)
    {
       
        if (count < 5)
        {
            [topBG addObject:dataPC];
            count++;
        }
        else
        {
            break;
            
        }
        
    }
    maxBarValue  = [sortedEventArray objectAtIndex:0];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:maxBarValue]  forKey:@"maxBarValue"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:topBG] forKey:@"topBG"];
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
