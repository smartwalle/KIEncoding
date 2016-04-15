//
//  KIRSAPrivateKey.m
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "KIRSAPrivateKey.h"
#import <openssl/pem.h>

@implementation KIRSAPrivateKey

- (instancetype)initWithFile:(NSString *)file {
    return nil;
}

- (instancetype)initWithData:(NSData *)data {
    return nil;
}

- (NSData *)_encrypt:(NSData *)plainData error:(NSError **)error {
    NSMutableData *cipherData = [NSMutableData dataWithLength:self.RSASize];
    int cLen = RSA_private_encrypt((int)plainData.length, plainData.bytes, cipherData.mutableBytes, _rsa, self.padding);
    if (cLen < 0) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    [cipherData setLength:cLen];
    return cipherData;
}

- (NSData *)_decrypt:(NSData *)cipherData error:(NSError **)error {
    NSUInteger len = [cipherData length];

    NSMutableData *plainData = [NSMutableData dataWithLength:self.RSASize];
    int pLen = RSA_private_decrypt((int)len, cipherData.bytes, plainData.mutableBytes, _rsa, self.padding);
    if (pLen < 0) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    [plainData setLength:pLen];
    return plainData;
}

@end
