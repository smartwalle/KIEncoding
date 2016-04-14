//
//  NSData+KIDigest.m
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSData+KIDigest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (KIDigest)

- (NSData *)MD5 {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *)SHA1 {
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *)SHA224 {
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_SHA224_DIGEST_LENGTH];
}

- (NSData *)SHA256 {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
}

- (NSData *)SHA384 {
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_SHA384_DIGEST_LENGTH];
}

- (NSData *)SHA512 {
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_SHA512_DIGEST_LENGTH];
}

@end
