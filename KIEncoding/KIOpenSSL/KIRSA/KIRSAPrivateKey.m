//
//  KIRSAPrivateKey.m
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "KIRSAPrivateKey.h"
#import <openssl/pem.h>
#import <openssl/md5.h>

@implementation KIRSAPrivateKey

+ (KIRSAPrivateKey *)keyWithFile:(NSString *)file {
    return [KIRSAPrivateKey keyWithFile:file password:nil];
}

+ (KIRSAPrivateKey *)keyWithFile:(NSString *)file password:(NSString *)password {
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
    
    KIRSAPrivateKey *key = [[KIRSAPrivateKey alloc] initWithRSA:rsa];
    RSA_free(rsa);
    return key;
}

+ (KIRSAPrivateKey *)keyWithData:(NSData *)data {
    return [KIRSAPrivateKey keyWithData:data password:nil];
}

+ (KIRSAPrivateKey *)keyWithData:(NSData *)data password:(NSString *)password {
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
    
    KIRSAPrivateKey *key = [[KIRSAPrivateKey alloc] initWithRSA:rsa];
    RSA_free(rsa);
    return key;
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

- (NSData *)signWithSHA128:(NSData *)plainData error:(NSError **)error {
    SHA_CTX ctx;
    unsigned char messageDigest[SHA_DIGEST_LENGTH];
    if (!SHA1_Init(&ctx)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    if (!SHA1_Update(&ctx, plainData.bytes, plainData.length)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    if (!SHA1_Final(messageDigest, &ctx)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    
    NSMutableData *signature = [NSMutableData dataWithLength:self.RSASize];
    unsigned int sLength = 0;
    if (!RSA_sign(NID_sha1, messageDigest, SHA_DIGEST_LENGTH, signature.mutableBytes, &sLength, _rsa)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    [signature setLength:sLength];
    
    return signature;
}

- (NSData *)signWithSHA256:(NSData *)plainData error:(NSError **)error {
    SHA256_CTX ctx;
    unsigned char digestData[SHA256_DIGEST_LENGTH];
    if (!SHA256_Init(&ctx)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    if (!SHA256_Update(&ctx, plainData.bytes, plainData.length)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    if (!SHA256_Final(digestData, &ctx)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    
    NSMutableData *signature = [NSMutableData dataWithLength:self.RSASize];
    unsigned int sLength = 0;
    if (!RSA_sign(NID_sha256, digestData, SHA256_DIGEST_LENGTH, signature.mutableBytes, &sLength, _rsa)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    [signature setLength:sLength];
    
    return signature;
}

- (NSData *)signWithMD5:(NSData *)plainData error:(NSError **)error {
    MD5_CTX ctx;
    unsigned char messageDigest[MD5_DIGEST_LENGTH];
    if (!MD5_Init(&ctx)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    if (!MD5_Update(&ctx, plainData.bytes, plainData.length)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    if (!MD5_Final(messageDigest, &ctx)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    
    NSMutableData *signature = [NSMutableData dataWithLength:self.RSASize];
    unsigned int sLength = 0;
    if (!RSA_sign(NID_md5, messageDigest, MD5_DIGEST_LENGTH, signature.mutableBytes, &sLength, _rsa)) {
        if (error != nil) {
            *error = [KIRSAPrivateKey RSAError];
        }
        return nil;
    }
    [signature setLength:sLength];
    
    return signature;
}

@end
