//
//  iOSRequest.h
//  ICD_iOSPrototype
//
//  Created by Filipe Ferreira on 12/25/13.
//  Copyright (c) 2013 Filipe Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
typedef void(^RequestCompletionHandler) (NSString*, NSError*);

@interface iOSRequest : NSObject
   
+(void)requestToPath:(NSString*)search onCompletion:(RequestCompletionHandler)complete;
+(void)requestPathValidate:(NSString*)search onCompletion:(RequestCompletionHandler)complete;

@end
