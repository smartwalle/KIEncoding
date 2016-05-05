//
//  NSData+KIPKCS5.m
//  KIEncoding
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSData+KIPKCS5.h"

@implementation NSData (KIPKCS5)

- (NSData *)PBKDF2WithSalt:(NSData *)salt kenLen:(int)kenLen {
    return [self PBKDF2WithSalt:salt iter:0 digest:NULL kenLen:kenLen];
}

- (NSData *)PBKDF2WithSalt:(NSData *)salt iter:(int)iter digest:(const EVP_MD *)digest kenLen:(int)kenLen {
    if (salt == nil) {
        return nil;
    }
    if (iter <= 0) {
        iter = PKCS5_DEFAULT_ITER;
    }
    if (digest == NULL) {
        digest = EVP_md5();
    }
    if (kenLen <= 0) {
        kenLen = EVP_MAX_KEY_LENGTH;
    }
    unsigned char key[kenLen];
    NSData *output = nil;
    if (PKCS5_PBKDF2_HMAC([self bytes], (int)self.length, [salt bytes], (int)salt.length, iter, digest, kenLen, key) == 1) {
        output = [NSData dataWithBytes:key length:kenLen];
    }
    return output;
}

@end
