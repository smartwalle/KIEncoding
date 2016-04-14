//
//  NSData+KIDigest.h
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (KIDigest)

- (NSData *)MD5;

- (NSData *)SHA1;

- (NSData *)SHA224;

- (NSData *)SHA256;

- (NSData *)SHA384;

- (NSData *)SHA512;

@end
