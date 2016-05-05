//
//  NSData+KIOpenSSL.m
//  KIEncoding
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSData+KIOpenSSL.h"
#import <openssl/rand.h>

@implementation NSData (KIOpenSSL)

+ (NSData *)RANDBytes:(int)len {
    unsigned char salt[len];
    if (RAND_bytes(salt, len) == 0) {
        return nil;
    }
    NSData *data = [NSData dataWithBytes:salt length:len];
    return data;
}

@end
