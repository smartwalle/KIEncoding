//
//  NSData+KIHMAC.h
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (KIHMAC)

- (NSData *)hmacMD5:(NSString *)key;

- (NSData *)hmacSHA1:(NSString *)key;

- (NSData *)hmacSHA224:(NSString *)key;

- (NSData *)hmacSHA256:(NSString *)key;

- (NSData *)hmacSHA384:(NSString *)key;

- (NSData *)hmacSHA512:(NSString *)key;

@end
