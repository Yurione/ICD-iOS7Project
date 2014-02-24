//
//  BaseElement.h
//  ICD_iOSPrototype
//
//  Created by Filipe Ferreira on 12/27/13.
//  Copyright (c) 2013 Filipe Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeICD : NSObject<NSCoding>{
    
    NSString *Id;
    NSString *Code;
    NSString *Preferred;
    NSString *Type;
    NSString *HtmlResult;
    NSString *Superclass;

}

@property (nonatomic, retain) NSString *Id;
@property (nonatomic, retain) NSString *Code;
@property (nonatomic, retain) NSString *Preferred;
@property (nonatomic, retain) NSString *Type;
@property (nonatomic, retain) NSString *HtmlResult;
@property (nonatomic, retain) NSString *Superclass;

-(id)initWithId:(NSString *)identi andCode:(NSString *)code andPreferred:(NSString *)preferred andType:(NSString *)type andHtml:(NSString *)html
       andSuper:(NSString *)superclass;

@end
