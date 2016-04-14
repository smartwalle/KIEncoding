//
//  NSString+KIEncoding.h
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+KIEncoding.h"

@interface NSString (KIEncoding)

- (NSData *)dataUsingUTF8Encoding;

- (NSData *)dataUsingHex;

- (NSString *)base64Encoded;

- (NSData *)base64Decoded;

@end
