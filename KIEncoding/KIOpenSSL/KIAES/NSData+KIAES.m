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
#import <openssl/rand.h>

NSString * const KIAESDefaultMagic = @"Salted__";

@implementation NSData (KIAES)

#pragma mark - Encrypt
- (NSData *)AESEncryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits key:(NSData *)key iv:(NSData *)iv {
    OpenSSL_add_all_algorithms();
    
    const EVP_CIPHER *cipher = [self cipherWithMode:mode bits:bits];
    if (cipher == nil) {
        return nil;
    }
    
    return [self AESEncryptWithCipher:cipher key:(unsigned char *)[key bytes] iv:(unsigned char *)[iv bytes] salt:NULL magic:nil];
}

- (NSData *)AESEncryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits password:(NSData *)password {
    return [self AESEncryptWithMode:mode bits:bits password:password saltType:KIAESSaltType_BytesToKey];
}

- (NSData *)AESEncryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits password:(NSData *)password saltType:(KIAESSaltType)saltType {
    return [self AESEncryptWithMode:mode bits:bits password:password saltType:saltType saltDigest:EVP_md5() iterCount:0];
}

- (NSData *)AESEncryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                      password:(NSData *)password
                      saltType:(KIAESSaltType)saltType
                    saltDigest:(const EVP_MD *)saltDigest
                     iterCount:(int)iterCount {
    return [self AESEncryptWithMode:mode
                               bits:bits
                           password:password
                           saltType:saltType
                         saltDigest:saltDigest
                          iterCount:iterCount
                              magic:KIAESDefaultMagic];
}

- (NSData *)AESEncryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                      password:(NSData *)password
                      saltType:(KIAESSaltType)saltType
                    saltDigest:(const EVP_MD *)saltDigest
                     iterCount:(int)iterCount
                         magic:(NSString *)magic {
    OpenSSL_add_all_algorithms();
    
    const EVP_CIPHER *cipher = [self cipherWithMode:mode bits:bits];
    if (cipher == nil) {
        return nil;
    }
    
    if (magic == nil) {
        magic = KIAESDefaultMagic;
    }
    
    int keySize = bits / 8;
    unsigned char key[keySize];
    unsigned char iv[EVP_MAX_IV_LENGTH];
    unsigned char salt[PKCS5_SALT_LEN];
    
    if (RAND_bytes(salt, PKCS5_SALT_LEN) == 0) {
        return nil;
    }
    
    if (saltDigest == nil) {
        saltDigest = EVP_md5();
    }
    
    if (saltType == KIAESSaltType_PBKDF2) {
        if (iterCount <= 0) {
            iterCount = PKCS5_DEFAULT_ITER;
        }
        if (PKCS5_PBKDF2_HMAC([password bytes], (int)[password length], salt, PKCS5_SALT_LEN, iterCount, saltDigest, keySize, key) == 0) {
            return nil;
        }
        if (PKCS5_PBKDF2_HMAC((char *)key, keySize, salt, PKCS5_SALT_LEN, iterCount, saltDigest, EVP_MAX_IV_LENGTH, iv) == 0) {
            return nil;
        }
    } else {
        if (iterCount <= 0) {
            iterCount = 1;
        }
        if(EVP_BytesToKey(cipher, saltDigest, salt, [password bytes], (int)[password length], iterCount, key, iv) == 0) {
            return nil;
        }
    }
    
#if DEBUG
    NSLog(@"AES Encrypt:");
    NSLog(@"AES Key: %@", [NSData dataWithBytes:key length:keySize]);
    NSLog(@"AES IV: %@", [NSData dataWithBytes:iv length:sizeof(iv)]);
    NSLog(@"AES SALT: %@", [NSData dataWithBytes:salt length:sizeof(salt)]);
#endif
    
    return [self AESEncryptWithCipher:cipher key:key iv:iv salt:salt magic:magic];
}

- (NSData *)AESEncryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                           key:(NSData *)key
                            iv:(NSData *)iv
                          salt:(NSData *)salt {
    return [self AESEncryptWithMode:mode bits:bits key:key iv:iv salt:salt magic:KIAESDefaultMagic];
}

- (NSData *)AESEncryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                           key:(NSData *)key
                            iv:(NSData *)iv
                          salt:(NSData *)salt
                         magic:(NSString *)magic {
    OpenSSL_add_all_algorithms();
    
    const EVP_CIPHER *cipher = [self cipherWithMode:mode bits:bits];
    if (cipher == nil) {
        return nil;
    }
    
    return [self AESEncryptWithCipher:cipher key:(unsigned char *)[key bytes] iv:(unsigned char *)[iv bytes] salt:(unsigned char *)[salt bytes] magic:magic];
}

- (NSData *)AESEncryptWithCipher:(const EVP_CIPHER *)cipher
                             key:(unsigned char *)key
                              iv:(unsigned char *)iv
                            salt:(unsigned char *)salt
                           magic:(NSString *)magic {
    unsigned char *resultBytes = (unsigned char *) malloc(self.length + AES_BLOCK_SIZE);
    memset(resultBytes, 0, self.length + AES_BLOCK_SIZE);
    if (resultBytes == NULL) {
        return nil;
    }
    
    size_t blockLength = 0;
    size_t length = 0;
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    
    NSMutableData *ciphertext = [[NSMutableData alloc] init];
    
    if (salt != NULL && magic != nil) {
        const char *mByte = [magic UTF8String];
        [ciphertext appendBytes:mByte length:magic.length];
        
        unsigned char sByte[PKCS5_SALT_LEN];
        bcopy(salt, sByte, PKCS5_SALT_LEN);
        [ciphertext appendBytes:sByte  length:PKCS5_SALT_LEN];
    }
    
    if (EVP_EncryptInit_ex(ctx, cipher, NULL, key, iv)) {
        if (EVP_EncryptUpdate(ctx, resultBytes, (int *)&blockLength, self.bytes, (int)self.length)) {
            length += blockLength;
            if (EVP_EncryptFinal(ctx, resultBytes + length, (int *)&blockLength)) {
                length += blockLength;
                [ciphertext appendBytes:resultBytes length:length];
            }
        }
    }
    free(resultBytes);
    EVP_CIPHER_CTX_cleanup(ctx);
    EVP_CIPHER_CTX_free(ctx);
    
    return ciphertext;
}

#pragma mark - Decrypt
- (NSData *)AESDecryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits key:(NSData *)key iv:(NSData *)iv {
    OpenSSL_add_all_algorithms();
    
    const EVP_CIPHER *cipher = [self cipherWithMode:mode bits:bits];
    if (cipher == nil) {
        return nil;
    }
    
    return [self AESDecryptWithCipher:cipher key:(unsigned char *)[key bytes] iv:(unsigned char *)[iv bytes] salted:NO magic:nil];
}

- (NSData *)AESDecryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits password:(NSData *)password {
    return [self AESDecryptWithMode:mode bits:bits password:password saltType:KIAESSaltType_BytesToKey];
}

- (NSData *)AESDecryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits password:(NSData *)password saltType:(KIAESSaltType)saltType {
    return [self AESDecryptWithMode:mode bits:bits password:password saltType:saltType saltDigest:EVP_md5() iterCount:0];
}

- (NSData *)AESDecryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                      password:(NSData *)password
                      saltType:(KIAESSaltType)saltType
                    saltDigest:(const EVP_MD *)saltDigest
                     iterCount:(int)iterCount {
    return [self AESDecryptWithMode:mode
                               bits:bits
                           password:password
                           saltType:saltType
                         saltDigest:saltDigest
                          iterCount:iterCount
                              magic:KIAESDefaultMagic];
}


- (NSData *)AESDecryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                      password:(NSData *)password
                      saltType:(KIAESSaltType)saltType
                    saltDigest:(const EVP_MD *)saltDigest
                     iterCount:(int)iterCount
                         magic:(NSString *)magic {
    OpenSSL_add_all_algorithms();
    
    const EVP_CIPHER *cipher = [self cipherWithMode:mode bits:bits];
    if (cipher == nil) {
        return nil;
    }
    
    if (magic == nil) {
        magic = KIAESDefaultMagic;
    }
    
    int keySize = bits / 8;
    unsigned char key[keySize];
    unsigned char iv[EVP_MAX_IV_LENGTH];
    unsigned char salt[PKCS5_SALT_LEN];
    
    if (self.length < magic.length - 1 + PKCS5_SALT_LEN) {
        return nil;
    }
    
    if (memcmp([self bytes], [magic UTF8String], magic.length) != 0) {
        return nil;
    }
    bcopy([self bytes] + magic.length, salt, PKCS5_SALT_LEN);
    
    if (saltDigest == nil) {
        saltDigest = EVP_md5();
    }
    
    if (saltType == KIAESSaltType_PBKDF2) {
        if (iterCount <= 0) {
            iterCount = PKCS5_DEFAULT_ITER;
        }
        if (PKCS5_PBKDF2_HMAC([password bytes], (int)[password length], salt, sizeof(salt), iterCount, saltDigest, keySize, key) == 0) {
            return nil;
        }
        if (PKCS5_PBKDF2_HMAC((char *)key, keySize, salt, sizeof(salt), iterCount, saltDigest, EVP_MAX_IV_LENGTH, iv) == 0) {
            return nil;
        }
    } else {
        if (iterCount <= 0) {
            iterCount = 1;
        }
        if(EVP_BytesToKey(cipher, saltDigest, salt, [password bytes], (int)[password length], iterCount, key, iv) == 0) {
            return nil;
        }
    }
    
#if DEBUG
    NSLog(@"AES Decrypt:");
    NSLog(@"AES Key: %@", [NSData dataWithBytes:key length:keySize]);
    NSLog(@"AES IV: %@", [NSData dataWithBytes:iv length:sizeof(iv)]);
    NSLog(@"AES SALT: %@", [NSData dataWithBytes:salt length:sizeof(salt)]);
#endif
    
    return [self AESDecryptWithCipher:cipher key:key iv:iv salted:YES magic:magic];
}

- (NSData *)AESDecryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                           key:(NSData *)key
                            iv:(NSData *)iv
                        salted:(BOOL)salted {
    OpenSSL_add_all_algorithms();
    
    const EVP_CIPHER *cipher = [self cipherWithMode:mode bits:bits];
    if (cipher == nil) {
        return nil;
    }
    
    return [self AESDecryptWithCipher:cipher key:(unsigned char *)[key bytes] iv:(unsigned char *)[iv bytes] salted:salted magic:KIAESDefaultMagic];
}

- (NSData *)AESDecryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                           key:(NSData *)key
                            iv:(NSData *)iv
                         magic:(NSString *)magic {
    OpenSSL_add_all_algorithms();
    
    const EVP_CIPHER *cipher = [self cipherWithMode:mode bits:bits];
    if (cipher == nil) {
        return nil;
    }
    
    return [self AESDecryptWithCipher:cipher key:(unsigned char *)[key bytes] iv:(unsigned char *)[iv bytes] salted:(magic!=nil) magic:magic];
}

- (NSData *)AESDecryptWithCipher:(const EVP_CIPHER *)cipher
                             key:(unsigned char *)key
                              iv:(unsigned char *)iv
                          salted:(BOOL)salted
                           magic:(NSString *)magic {
    unsigned char *resultBytes = (unsigned char *) malloc(self.length);
    if (resultBytes == NULL) {
        return nil;
    }
    
    size_t blockLength = 0;
    size_t length = 0;
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    
    int offset = 0;
    if (salted) {
        offset += PKCS5_SALT_LEN;
        if (magic != nil) {
            offset += (int)magic.length;
        }
    }
    
    NSData *plaintext = nil;
    if (EVP_DecryptInit_ex(ctx, cipher, NULL, key, iv)) {
        if (EVP_DecryptUpdate(ctx, resultBytes, (int *)&blockLength, self.bytes + offset, (int)self.length-offset)) {
            length += blockLength;
            if (EVP_DecryptFinal_ex(ctx, resultBytes + length, (int *)&blockLength)) {
                length += blockLength;
                plaintext = [NSData dataWithBytes:resultBytes length:length];
            }
            
        }
    }
    free(resultBytes);
    EVP_CIPHER_CTX_cleanup(ctx);
    EVP_CIPHER_CTX_free(ctx);
    
    return plaintext;
}


#pragma mark - Cipher
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

- (NSData *)salt {
    return [self saltWithMagic:KIAESDefaultMagic];
}

- (NSData *)saltWithMagic:(NSString *)magic {
    unsigned char salt[PKCS5_SALT_LEN];
    
    if (self.length < magic.length - 1 + PKCS5_SALT_LEN) {
        return nil;
    }
    
    if (memcmp([self bytes], [magic UTF8String], magic.length) != 0) {
        return nil;
    }
    bcopy([self bytes] + magic.length, salt, PKCS5_SALT_LEN);
    
    return [NSData dataWithBytes:salt length:PKCS5_SALT_LEN];
}

@end
