//
//  GDataParser.m
//  ICDEasyOn
//
//  Created by Filipe Ferreira on 22/02/14.
//  Copyright (c) 2014 Filipe Ferreira. All rights reserved.
//

#import "GDataParser.h"
#import "GDataXMLNode.h"
#import "CodeICD.h"

@implementation GDataParser

+ (NSString *)dataFilePath:(BOOL)forSave {
    return [[NSBundle mainBundle] pathForResource:@"bookmarks" ofType:@"xml"];
}

+ (NSMutableArray *)loadFile {
    
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (error != nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parser Error" message:@"Bookmarks file corrupted!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        
        [alert show];
        
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *codeMembers = [doc.rootElement elementsForName:@"entry"];
    for (GDataXMLElement *partyMember in codeMembers) {
        
        // Let's fill these in!
        NSString *Id;
        NSString *Code;
        NSString *Preferred;
        NSString *HtmlResult;
        NSString *Type;
        NSString *Superclass;
        
        NSArray *childMembers = [partyMember nodesForXPath:@"child::*" error:nil];
        GDataXMLNode *node =  [partyMember attributeForName:@"id"];
        Id = node.name;
        
        for (GDataXMLNode *node in childMembers) {
            
            if ([node.name isEqualToString:@"code"]) {
                Code = node.stringValue;
            }
            else if([node.name isEqualToString:@"preferred"]){
                Preferred = node.stringValue;
            }
            else if([node.name isEqualToString:@"htmlResult"]){
                HtmlResult = node.stringValue;
            }
            else if([node.name isEqualToString:@"type"]){
                Type = node.stringValue;
            }
            
        }
        CodeICD *codeICD = [[CodeICD alloc] initWithId:Id andCode:Code andPreferred:Preferred andType:Type andHtml:HtmlResult andSuper:Superclass];
       [array addObject:codeICD];
          
        
        
    }
    
   
    return array;
    
}

@end
