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
+(void)requestToPath:(NSString *)search titleC:(BOOL )title definitionC:(BOOL )definition noteC:(BOOL)note inclusionC:(BOOL )inclusion exclusionC:(BOOL)exclusion codingC:(BOOL)codingHint onCompletion:(RequestCompletionHandler)complete
{
    
    search = [search URLEncode];
    NSString *titleS = (title) ? @"True" : @"False";
    NSString *definitionS = (definition) ? @"True" : @"False";
    NSString *noteS = (note) ? @"True" : @"False";
    NSString *inclusionS = (inclusion) ? @"True" : @"False";
    NSString *exclusionS = (exclusion) ? @"True" : @"False";
    NSString *codingS = (codingHint) ? @"True" : @"False";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    
    [defaults setObject:@"http://icdalmost.apphb.com/ServiceICDEasyOn.svc/Rest/getcodes" forKey:@"addressURL"];
    [defaults synchronize];
    
    NSString *basePath = [defaults stringForKey:@"addressURL"];
    NSString *fullPath = [basePath stringByAppendingFormat:@"?search=%@&title=%@&definition=%@&inclusion=%@&exclusion=%@&note=%@&codingHint=%@",search,titleS,definitionS,inclusionS,exclusionS,noteS,codingS];

    
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
