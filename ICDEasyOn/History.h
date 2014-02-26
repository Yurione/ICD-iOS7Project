//
//  History.h
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 26/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject<NSCoding>{
    NSString *keyword;
    NSInteger identifier;
    NSDate *date;
    NSDictionary *options;
    
}
@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,assign)NSInteger identifier;
@property(nonatomic,strong)NSDate *date;
@property(nonatomic,strong)NSDictionary *options;

-(id)initWithKeyword:(NSString *) aKeyword andDate:(NSDate *) aDate andOptions:(NSDictionary *) aOptions;

@end
