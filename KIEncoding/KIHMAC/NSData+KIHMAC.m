//
//  NSData+KIHMAC.m
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSData+KIHMAC.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSData (KIHMAC)

- (NSData *)hmacMD5:(NSString *)key {
    return [self hmacWithAlgorithm:kCCHmacAlgMD5 key:key length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *)hmacSHA1:(NSString *)key {
    return [self hmacWithAlgorithm:kCCHmacAlgSHA1 key:key length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *)hmacSHA224:(NSString *)key {
    return [self hmacWithAlgorithm:kCCHmacAlgSHA224 key:key length:CC_SHA224_DIGEST_LENGTH];
}

- (NSData *)hmacSHA256:(NSString *)key {
    return [self hmacWithAlgorithm:kCCHmacAlgSHA256 key:key length:CC_SHA256_DIGEST_LENGTH];
}

- (NSData *)hmacSHA384:(NSString *)key {
    return [self hmacWithAlgorithm:kCCHmacAlgSHA384 key:key length:CC_SHA384_DIGEST_LENGTH];
}

- (NSData *)hmacSHA512:(NSString *)key {
    return [self hmacWithAlgorithm:kCCHmacAlgSHA512 key:key length:CC_SHA512_DIGEST_LENGTH];
}

- (NSData *)hmacWithAlgorithm:(CCHmacAlgorithm)alg key:(NSString *)key length:(NSUInteger)length {
    if (key == nil) {
        key = @"";
    }
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char result[length];
    CCHmac(alg, cKey, strlen(cKey), [self bytes], [self length], result);
    return [NSData dataWithBytes:result length:length];
}

@end
