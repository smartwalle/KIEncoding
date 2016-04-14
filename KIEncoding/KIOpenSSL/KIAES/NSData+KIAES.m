//
//  NSData+KIAES.m
//  KIEncoding
//
//  Created by SmartWalle on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSData+KIAES.h"
#import <openssl/aes.h>
#import <openssl/evp.h>

@implementation NSData (KIAES)

- (NSData *)AESEncryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits key:(NSString *)key iv:(NSString *)iv {
    size_t blockLength = 0;
    size_t length = 0;
    
    EVP_CIPHER_CTX ctx;
    
    const EVP_CIPHER *cipher = [self cipherWithMode:mode bits:bits];
    if (cipher == nil) {
        return nil;
    }
    
    unsigned char *resultBytes = (unsigned char *) malloc(self.length + AES_BLOCK_SIZE);
    memset(resultBytes, 0, self.length + AES_BLOCK_SIZE);
    if (resultBytes == NULL) {
        return nil;
    }
    
    if (!EVP_EncryptInit(&ctx, cipher, (unsigned char *)[key UTF8String], (unsigned char *)[iv UTF8String])) {
        free(resultBytes);
        return nil;
    }
    
    if (!EVP_EncryptUpdate(&ctx, resultBytes, (int *) &blockLength, self.bytes, (int)self.length)) {
        free(resultBytes);
        return nil;
    }
    length += blockLength;
    
    if (!EVP_EncryptFinal(&ctx, resultBytes + length, (int *) &blockLength)) {
        free(resultBytes);
        return nil;
    }
    length += blockLength;
    
    return [NSData dataWithBytesNoCopy:resultBytes length:length];
}


- (NSData *)AESDecryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits key:(NSString *)key iv:(NSString *)iv {
    size_t blockLength = 0;
    size_t length = 0;
    
    EVP_CIPHER_CTX ctx;
    
    const EVP_CIPHER *cipher = [self cipherWithMode:mode bits:bits];
    if (cipher == nil) {
        return nil;
    }
    
    unsigned char *resultBytes = (unsigned char *) malloc(self.length);
    if (resultBytes == NULL) {
        return nil;
    }
    
    if (!EVP_DecryptInit(&ctx, cipher, (unsigned char *)[key UTF8String], (unsigned char *)[iv UTF8String])) {
        free(resultBytes);
        return nil;
    }
    
    if (!EVP_DecryptUpdate(&ctx, resultBytes, (int *) &blockLength, self.bytes, (int)self.length)) {
        free(resultBytes);
        return nil;
    }
    length += blockLength;
    
    if (!EVP_DecryptFinal(&ctx, resultBytes + length, (int *) &blockLength)) {
        free(resultBytes);
        return nil;
    }
    length += blockLength;
    
    return [NSData dataWithBytesNoCopy:resultBytes length:length];
}

- (const EVP_CIPHER *)cipherWithMode:(KIAESMode)mode bits:(KIAESBits)bits {
    switch (mode) {
        case KIAESMode_ECB:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_ecb();
                case KIAESBits_192:
                    return EVP_aes_192_ecb();
                case KIAESBits_128:
                    return EVP_aes_128_ecb();
            }
            break;
        case KIAESMode_CBC:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_cbc();
                case KIAESBits_192:
                    return EVP_aes_192_cbc();
                case KIAESBits_128:
                    return EVP_aes_128_cbc();
            }
            break;
        case KIAESMode_CFB:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_cfb();
                case KIAESBits_192:
                    return EVP_aes_192_cfb();
                case KIAESBits_128:
                    return EVP_aes_128_cfb();
            }
            break;
        case KIAESMode_CFB1:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_cfb1();
                case KIAESBits_192:
                    return EVP_aes_192_cfb1();
                case KIAESBits_128:
                    return EVP_aes_128_cfb1();
            }
            break;
        case KIAESMode_CFB8:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_cfb8();
                case KIAESBits_192:
                    return EVP_aes_192_cfb8();
                case KIAESBits_128:
                    return EVP_aes_128_cfb8();
            }
            break;
        case KIAESMode_CFB128:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_cfb128();
                case KIAESBits_192:
                    return EVP_aes_192_cfb128();
                case KIAESBits_128:
                    return EVP_aes_128_cfb128();
            }
            break;
        case KIAESMode_OFB:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_ofb();
                case KIAESBits_192:
                    return EVP_aes_192_ofb();
                case KIAESBits_128:
                    return EVP_aes_128_ofb();
            }
            break;
        case KIAESMode_CTR:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_ctr();
                case KIAESBits_192:
                    return EVP_aes_192_ctr();
                case KIAESBits_128:
                    return EVP_aes_128_ctr();
            }
            break;
        case KIAESMode_CCM:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_ccm();
                case KIAESBits_192:
                    return EVP_aes_192_ccm();
                case KIAESBits_128:
                    return EVP_aes_128_ccm();
            }
            break;
        case KIAESMode_GCM:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_gcm();
                case KIAESBits_192:
                    return EVP_aes_192_gcm();
                case KIAESBits_128:
                    return EVP_aes_128_gcm();
            }
            break;
        case KIAESMode_XTS:
            switch(bits) {
                case KIAESBits_256:
                    return EVP_aes_256_xts();
                case KIAESBits_192:
                    return nil;
                case KIAESBits_128:
                    return EVP_aes_128_xts();
            }
            break;
    }
    return nil;
}

@end
