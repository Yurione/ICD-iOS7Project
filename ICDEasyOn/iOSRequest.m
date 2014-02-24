//
//  iOSRequest.m
//  ICD_iOSPrototype
//
//  Created by Filipe Ferreira on 12/25/13.
//  Copyright (c) 2013 Filipe Ferreira. All rights reserved.
//

#import "iOSRequest.h"
#import "Parser.h"
#import "NSString+WebService.h"

@implementation iOSRequest
+(void)requestToPath:(NSString *)search onCompletion:(RequestCompletionHandler)complete
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

    search = [search URLEncode];
    NSString *titleS = ([defaults boolForKey:@"titleChecked"]) ? @"True" : @"False";
    NSString *definitionS = ([defaults boolForKey:@"definitionChecked"]) ? @"True" : @"False";
    NSString *noteS = ([defaults boolForKey:@"noteCkecked"]) ? @"True" : @"False";
    NSString *inclusionS = ([defaults boolForKey:@"inclusionChecked"]) ? @"True" : @"False";
    NSString *exclusionS = ([defaults boolForKey:@"exclusionChecked"]) ? @"True" : @"False";
    NSString *codingS = ([defaults boolForKey:@"codingChecked"]) ? @"True" : @"False";
    

   
    
    [defaults setObject:@"http://icdalmost.apphb.com/ServiceICDEasyOn.svc/Rest/getcodes" forKey:@"addressURL"];
    [defaults synchronize];
    
    NSString *basePath = [defaults stringForKey:@"addressURL"];
    NSString *fullPath = [basePath stringByAppendingFormat:@"?search=%@&title=%@&definition=%@&inclusion=%@&exclusion=%@&note=%@&codingHint=%@",search,titleS,definitionS,inclusionS,exclusionS,noteS,codingS];

    NSLog(@"%@",fullPath);
    
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:fullPath]
                                                  cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                              timeoutInterval:200];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               
                               NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
        
                               
                               Parser *theParser = [[Parser alloc] initParser];
                               
                               [xmlParser setDelegate:theParser];
                               
                               BOOL worked = [xmlParser parse];
                               
                               if (worked) {
                                   NSLog(@"Parse with success!");
                               }
                               else {
                                   NSLog(@"Parse didn't worked!");
                               }
                               
                               NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               if(complete) complete(result,error);
                               
                           }];
    
    
}

@end
