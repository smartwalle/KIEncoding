//
//  KIRSAPublicKey.m
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "KIRSAPublicKey.h"
#import <openssl/pem.h>
#import <openssl/md5.h>

@implementation KIRSAPublicKey

+ (KIRSAPublicKey *)keyWithFile:(NSString *)file {
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
    PEM_read_bio_RSA_PUBKEY(bio, &rsa, NULL, NULL);
    if(rsa == NULL) {
        BIO_free_all(bio);
        bio = BIO_new_file([file UTF8String], "rb");
        rsa = PEM_read_bio_RSAPublicKey(bio, &rsa, NULL, NULL);
    }
    BIO_free_all(bio);
    if (rsa == NULL) {
        return nil;
    }
    
    KIRSAPublicKey *key = [[KIRSAPublicKey alloc] initWithRSA:rsa];
    RSA_free(rsa);
    return key;
}

+ (KIRSAPublicKey *)keyWithData:(NSData *)data {
    OpenSSL_add_all_algorithms();
    BIO *bio = BIO_new_mem_buf(data.bytes, -1);
    if (bio == NULL) {
        return nil;
    }
    
    RSA *rsa = NULL;
    PEM_read_bio_RSA_PUBKEY(bio, &rsa, 0, NULL);
    if (rsa == NULL) {
        BIO_free_all(bio);
        bio = BIO_new_mem_buf(data.bytes, -1);
        PEM_read_bio_RSAPublicKey(bio, &rsa, 0, NULL);
    }
    BIO_free_all(bio);
    if (rsa == NULL) {
        return nil;
    }
    
    KIRSAPublicKey *key = [[KIRSAPublicKey alloc] initWithRSA:rsa];
    RSA_free(rsa);
    return key;
}

- (NSData *)keyData {
    char *keyBytes;
    size_t keyLen;
    
    BIO *bio = BIO_new(BIO_s_mem());
    PEM_write_bio_RSA_PUBKEY(bio, _rsa);
    keyLen = (size_t)BIO_pending(bio);
    keyBytes = malloc(keyLen);
    BIO_read(bio, keyBytes, (int)keyLen);
    
    NSData *keyData = [NSData dataWithBytesNoCopy:keyBytes length:keyLen];
    return keyData;
}

- (NSString *)description {
    NSMutableString *dataString = [[NSMutableString alloc] initWithData:self.keyData
                                                               encoding:NSUTF8StringEncoding];
    return dataString;
}

- (NSData *)_encrypt:(NSData *)plainData blockSize:(int)blockSize error:(NSError **)error {
    NSMutableData *cipherData = [NSMutableData dataWithLength:self.RSASize];
    int cLen = RSA_public_encrypt((int)blockSize, plainData.bytes, cipherData.mutableBytes, _rsa, self.padding);
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
    NSMutableData *plainData = [NSMutableData dataWithLength:self.RSASize];
    int pLen = RSA_public_decrypt((int)cipherData.length, cipherData.bytes, plainData.mutableBytes, _rsa, self.padding);
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

- (BOOL)verifySignatureWithSHA128:(NSData *)signature plainData:(NSData *)plainData error:(NSError **)error {
    SHA_CTX ctx;
    unsigned char digestData[SHA_DIGEST_LENGTH];
    if(!SHA1_Init(&ctx)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    if (!SHA1_Update(&ctx, plainData.bytes, plainData.length)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    if (!SHA1_Final(digestData, &ctx)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    if (!RSA_verify(NID_sha1, digestData, SHA_DIGEST_LENGTH, signature.bytes, (int)signature.length, _rsa)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    return YES;
}

- (BOOL)verifySignatureWithSHA256:(NSData *)cipherData plainData:(NSData *)plainData error:(NSError **)error {
    SHA256_CTX ctx;
    unsigned char digestData[SHA256_DIGEST_LENGTH];
    if(!SHA256_Init(&ctx)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    if (!SHA256_Update(&ctx, plainData.bytes, plainData.length)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    if (!SHA256_Final(digestData, &ctx)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    if (!RSA_verify(NID_sha256, digestData, SHA256_DIGEST_LENGTH, cipherData.bytes, (int)cipherData.length, _rsa)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    return YES;
}

- (BOOL)verifySignatureWithMD5:(NSData *)signature plainData:(NSData *)plainData error:(NSError **)error {
    MD5_CTX ctx;
    unsigned char digestData[MD5_DIGEST_LENGTH];
    if(!MD5_Init(&ctx)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    if (!MD5_Update(&ctx, plainData.bytes, plainData.length)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    if (!MD5_Final(digestData, &ctx)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    if (!RSA_verify(NID_md5, digestData, MD5_DIGEST_LENGTH, signature.bytes, (int)signature.length, _rsa)) {
        if (error != nil) {
            *error = [KIRSAPublicKey RSAError];
        }
        return NO;
    }
    return YES;
}

@end
