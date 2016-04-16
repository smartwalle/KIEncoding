//
//  KIRSAPublicKey.m
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "KIRSAPublicKey.h"
#import <openssl/pem.h>

@implementation KIRSAPublicKey

- (instancetype)initWithFile:(NSString *)file {
    OpenSSL_add_all_algorithms();
    BIO *bio = BIO_new_file([file UTF8String], "rb");
    if (bio == NULL) {
        return nil;
    }
    
    /*
     PEM_read_bio_RSA_PUBKEY   =>  PEM_write_bio_RSA_PUBKEY 和 openssl 命令导出的公钥
     PEM_read_bio_RSAPublicKey =>  PEM_write_bio_RSAPublicKey
     */
    RSA *rsa = NULL;
    rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);
    if(rsa == NULL) {
        if (rsa == NULL) {
            BIO_free_all(bio);
            bio = BIO_new_file([file UTF8String], "rb");
            rsa = PEM_read_bio_RSAPublicKey(bio, NULL, NULL, NULL);
        }
    }
    BIO_free_all(bio);
    if (rsa == NULL) {
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
    int cLen = RSA_public_encrypt((int)plainData.length, plainData.bytes, cipherData.mutableBytes, _rsa, self.padding);
    if (cLen < 0) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return nil;
    }
    [cipherData setLength:cLen];
    return cipherData;
}

- (NSData *)_decrypt:(NSData *)cipherData error:(NSError **)error {
    NSUInteger len = [cipherData length];
    
    NSMutableData *plainData = [NSMutableData dataWithLength:self.RSASize];
    int pLen = RSA_public_decrypt((int)len, cipherData.bytes, plainData.mutableBytes, _rsa, self.padding);
    if (pLen < 0) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return nil;
    }
    [plainData setLength:pLen];
    return plainData;
}

- (BOOL)writeKeyToFile:(NSString *)file {
    if (file == nil) {
        return NO;
    }
    BIO *bio = BIO_new_file([file UTF8String], "w+");
    if (bio == NULL) {
        return NO;
    }
    
    int s = PEM_write_bio_RSA_PUBKEY(bio, _rsa);
    BIO_free_all(bio);
    if (s != 1) {
        return NO;
    }
    
    return YES;
}

@end
