//
//  NSString+KIDigest.h
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+KIEncoding.h"
#import "NSData+KIDigest.h"

@interface NSString (KIDigest)

- (NSString *)MD5;

- (NSString *)SHA1;

- (NSString *)SHA224;

- (NSString *)SHA256;

- (NSString *)SHA384;

- (NSString *)SHA512;

@end
