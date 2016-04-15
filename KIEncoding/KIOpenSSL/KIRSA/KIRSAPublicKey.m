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
//    OpenSSL_add_all_algorithms();
//    
//    BIO *bio = BIO_new_file([file UTF8String], "rb");
//    if(bio == NULL){
//        return nil;
//    }
//    
//    RSA *rsa = NULL;
//    
//    if((rsa=PEM_read_RSAPublicKey(bio ,NULL,NULL,NULL))==NULL){
//        ERR_print_errors_fp(stdout);
//        return 0;
//    }
//    
//    BIO_free(bio);
//    if(rsa == NULL) {
//        return nil;
//    }
//    
//    self = [self initWithRSA:rsa];
//    RSA_free(rsa);
//    return self;
    
    
    RSA *rsa = NULL;
    
    OpenSSL_add_all_algorithms();
    BIO *bp = BIO_new(BIO_s_file());;
    BIO_read_filename(bp, [file UTF8String]);
    if(NULL == bp)
    {
        printf("open_public_key bio file new error!\n");
        return NULL;
    }
    
    rsa = PEM_read_bio_RSAPublicKey(bp, NULL, NULL, NULL);
    if(rsa == NULL)
    {
        printf("open_public_key failed to PEM_read_bio_RSAPublicKey!\n");
        BIO_free(bp);
        RSA_free(rsa);
        
        return NULL;
    }
    
    printf("open_public_key success to PEM_read_bio_RSAPublicKey!\n");
    return nil;
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

@end
