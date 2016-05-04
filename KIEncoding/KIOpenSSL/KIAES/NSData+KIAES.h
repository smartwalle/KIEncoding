//
//  NSData+KIAES.h
//  KIEncoding
//
//  Created by SmartWalle on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/evp.h>

typedef NS_ENUM(int, KIAESMode) {
    KIAESMode_ECB = 0x01,
    KIAESMode_CBC,
    KIAESMode_CFB,
    KIAESMode_CFB1,
    KIAESMode_CFB8,
    KIAESMode_CFB128,
    KIAESMode_OFB,
    KIAESMode_CTR,
    KIAESMode_CCM,
    KIAESMode_GCM,
    KIAESMode_XTS,
};

typedef NS_ENUM(int, KIAESBits) {
    KIAESBits_128 = 128,     // 密码的长度为 16 个字节
    KIAESBits_192 = 192,     // 密码的长度为 24 个字节
    KIAESBits_256 = 256,     // 密码的长度为 32 个字节
};

typedef NS_ENUM(int, KIAESSaltType) {
    KIAESSaltType_BytesToKey = 1,
    KIAESSaltType_PBKDF2     = 2,
};

extern NSString *const KIAESDefaultMagic;

@interface NSData (KIAES)

- (NSData *)AESEncryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits key:(NSData *)key iv:(NSData *)iv;
- (NSData *)AESDecryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits key:(NSData *)key iv:(NSData *)iv;



- (NSData *)AESEncryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits password:(NSData *)password;
- (NSData *)AESEncryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits password:(NSData *)password saltType:(KIAESSaltType)saltType;

- (NSData *)AESEncryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                      password:(NSData *)password
                      saltType:(KIAESSaltType)saltType
                    saltDigest:(const EVP_MD *)saltDigest
                     iterCount:(int)iterCount;

- (NSData *)AESEncryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                      password:(NSData *)password
                      saltType:(KIAESSaltType)saltType
                    saltDigest:(const EVP_MD *)saltDigest
                     iterCount:(int)iterCount
                         magic:(NSString *)magic;

- (NSData *)AESEncryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                           key:(NSData *)key
                            iv:(NSData *)iv
                          salt:(NSData *)salt
                         magic:(NSString *)magic;



- (NSData *)AESDecryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits password:(NSData *)password;
- (NSData *)AESDecryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits password:(NSData *)password saltType:(KIAESSaltType)saltType;

- (NSData *)AESDecryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                      password:(NSData *)password
                      saltType:(KIAESSaltType)saltType
                    saltDigest:(const EVP_MD *)saltDigest
                     iterCount:(int)iterCount;

- (NSData *)AESDecryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                      password:(NSData *)password
                      saltType:(KIAESSaltType)saltType
                    saltDigest:(const EVP_MD *)saltDigest
                     iterCount:(int)iterCount
                         magic:(NSString *)magic;

- (NSData *)AESDecryptWithMode:(KIAESMode)mode
                          bits:(KIAESBits)bits
                           key:(NSData *)key
                            iv:(NSData *)iv
                         magic:(NSString *)magic;

@end