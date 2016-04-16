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
    return [self initWithFile:file password:nil];
}

- (instancetype)initWithFile:(NSString *)file password:(NSString *)password {
    OpenSSL_add_all_algorithms();
    
    BIO *bio = BIO_new_file([file UTF8String], "rb");
    if(bio == NULL){
        return nil;
    }
    
    RSA *rsa = NULL;
    PEM_read_bio_RSAPrivateKey(bio, &rsa, NULL, (void *)[password UTF8String]);
    BIO_free_all(bio);
    if(rsa == NULL) {
        return nil;
    }
    
    self = [self initWithRSA:rsa];
    RSA_free(rsa);
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithData:data password:nil];
}

- (instancetype)initWithData:(NSData *)data password:(NSString *)password {
    OpenSSL_add_all_algorithms();
    
    BIO *bio = BIO_new_mem_buf(data.bytes, -1);
    if(bio == NULL){
        return nil;
    }
    
    RSA *rsa = NULL;
    PEM_read_bio_RSAPrivateKey(bio, &rsa, NULL, (void *)[password UTF8String]);
    BIO_free_all(bio);
    if(rsa == NULL) {
        return nil;
    }
    
    self = [self initWithRSA:rsa];
    RSA_free(rsa);
    return self;
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

- (BOOL)writeKeyToFile:(NSString *)file {
    return [self writeKeyToFile:file cipher:NULL password:nil];
}

- (BOOL)writeKeyToFile:(NSString *)file password:(NSString *)password {
    return [self writeKeyToFile:file cipher:EVP_des_ede3_ofb() password:password];
}

- (BOOL)writeKeyToFile:(NSString *)file cipher:(const EVP_CIPHER *)enc password:(NSString *)password {
    if (file == nil) {
        return NO;
    }
    BIO *bio = BIO_new_file([file UTF8String], "w+");
    if (bio == NULL) {
        return NO;
    }
    
    int s = PEM_write_bio_RSAPrivateKey(bio, _rsa, enc, (unsigned char *)[password UTF8String], (int)[password length], NULL, NULL);
    BIO_free_all(bio);
    if (s != 1) {
        return NO;
    }
    
    return YES;
}

@end
