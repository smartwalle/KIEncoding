//
//  NSData+KIEncoding.h
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (KIEncoding)

+ (NSData *)dataWithHex:(NSString *)hex;

- (NSString *)hexString;

- (NSString *)base64Encoded;

- (NSData *)base64Decoded;

@end
