//
//  KIRSAKey.h
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/err.h>
#import <openssl/rsa.h>

@interface KIRSAKey : NSObject {
    int _rsaSize;
@protected
    RSA *_rsa;
}

// 目前支持 RSA_PKCS1_PADDING 、 RSA_PKCS1_OAEP_PADDING 、RSA_X931_PADDING和 RSA_NO_PADDING
// RSA_PKCS1_PADDING：     public key 和 private key 加密, 默认
// RSA_NO_PADDING：        public key 和 private key 加密，明文的长度必须为 128 byte， 不推荐
// RSA_PKCS1_OAEP_PADDING：public key 加密
// RSA_X931_PADDING：      private key 加密
@property (nonatomic, assign) int padding;

- (instancetype)initWithRSA:(RSA *)rsa;

- (RSA *)rsa;
- (int)RSASize;

- (dispatch_queue_t)concurrentQueue;

// 同步方法
- (NSData *)encrypt:(NSData *)plainData error:(NSError **)error;
- (NSData *)decrypt:(NSData *)cipherData error:(NSError **)error;

// 异步方法
- (void)encrypt:(NSData *)plainData finishedBlock:(void(^)(NSData *cipherData, NSError *error))block;
- (void)decrypt:(NSData *)cipherData finishedBlock:(void(^)(NSData *plainData, NSError *error))block;

- (NSData *)keyData;

@end

@interface KIRSAKey (Error)

+ (NSError *)RSAError;

@end
