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
     特别注释：
     
     对于同一份密钥，使用 openssl 命令导出的公钥和使用 openssl 代码生成的公钥在格式及值上都不一样，所以这里读取两次。
     第一次是针对 openssl 命令导出的公钥，该公钥采用 PEM_read_bio_RSA_PUBKEY 读取；
     第二次是针对 openssl 代码导出的公钥，该公钥采用 PEM_read_bio_RSAPublicKey 读取。
     
     命令生成的公钥:
     -----BEGIN PUBLIC KEY-----
     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
     -----END PUBLIC KEY-----

     
     代码生成的密钥:
     -----BEGIN RSA PUBLIC KEY-----
     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
     -----END RSA PUBLIC KEY-----
     
     最简单的区分办法就是判断 BGEIN 和 END 后面有没有 RSA。
     */
    
    RSA *rsa = NULL;
    rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);
    if(rsa == NULL) {
        if (rsa == NULL) {
            BIO_free(bio);
            bio = BIO_new_file([file UTF8String], "rb");
            rsa = PEM_read_bio_RSAPublicKey(bio, NULL, NULL, NULL);
        }
    }
    BIO_free(bio);
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

@end
