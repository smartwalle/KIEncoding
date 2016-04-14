//
//  NSString+KIHMAC.h
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+KIEncoding.h"
#import "NSData+KIHMAC.h"

@interface NSString (KIHMAC)

- (NSString *)hmacMD5:(NSString *)key;

- (NSString *)hmacSHA1:(NSString *)key;

- (NSString *)hmacSHA224:(NSString *)key;

- (NSString *)hmacSHA256:(NSString *)key;

- (NSString *)hmacSHA384:(NSString *)key;

- (NSString *)hmacSHA512:(NSString *)key;

@end
