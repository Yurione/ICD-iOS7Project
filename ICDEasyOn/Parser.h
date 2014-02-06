//
//  Parser.h
//  ICD_iOSPrototype
//
//  Created by Filipe Ferreira on 12/25/13.
//  Copyright (c) 2013 Filipe Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "CodeICD.h"

@interface Parser : NSObject <NSXMLParserDelegate>{
    AppDelegate *app;
    CodeICD *codeICD;
    NSMutableString *currentElementValue;
}

-(id)initParser;
@end
