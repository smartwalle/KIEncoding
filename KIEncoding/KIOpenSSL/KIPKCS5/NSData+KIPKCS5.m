//
//  NSData+KIPKCS5.m
//  KIEncoding
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSData+KIPKCS5.h"

@implementation NSData (KIPKCS5)

- (NSData *)PBKDF2WithSalt:(NSData *)salt keyLen:(int)keyLen {
    return [self PBKDF2WithSalt:salt iter:0 digest:NULL keyLen:keyLen];
}

- (NSData *)PBKDF2WithSalt:(NSData *)salt iter:(int)iter digest:(const EVP_MD *)digest keyLen:(int)keyLen {
    if (salt == nil) {
        return nil;
    }
    if (iter <= 0) {
        iter = PKCS5_DEFAULT_ITER;
    }
    if (digest == NULL) {
        digest = EVP_md5();
    }
    if (keyLen <= 0) {
        keyLen = EVP_MAX_KEY_LENGTH;
    }
    unsigned char key[keyLen];
    NSData *output = nil;
    if (PKCS5_PBKDF2_HMAC([self bytes], (int)self.length, [salt bytes], (int)salt.length, iter, digest, keyLen, key) == 1) {
        output = [NSData dataWithBytes:key length:keyLen];
    }
    return output;
}

@end
