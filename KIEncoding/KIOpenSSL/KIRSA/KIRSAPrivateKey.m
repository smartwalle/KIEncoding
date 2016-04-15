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

- (instancetype)initWithFile:(NSString *)file password:(NSString *)password {
    OpenSSL_add_all_algorithms();
    
    BIO *bio = BIO_new_file([file UTF8String], "rb");
    if(bio == NULL){
        return nil;
    }
    
    RSA *rsa = NULL;
    PEM_read_bio_RSAPrivateKey(bio, &rsa, NULL, (void *)[password UTF8String]);
    BIO_free(bio);
    if(rsa == NULL) {
        return nil;
    }
    
    self = [self initWithRSA:rsa];
    RSA_free(rsa);
    return self;
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
