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
   
+(void)requestToPath:(NSString*)search titleC:(BOOL)title definitionC:(BOOL)definition noteC:(BOOL)note inclusionC:(BOOL)inclusion exclusionC:(BOOL)exclusion codingC:(BOOL)codingHint onCompletion:(RequestCompletionHandler)complete;


@end
