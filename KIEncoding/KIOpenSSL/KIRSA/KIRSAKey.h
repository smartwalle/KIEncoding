//
//  KIRSAKey.h
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <openssl/err.h>
#import <openssl/rsa.h>

@interface KIRSAKey : NSObject {
    int _rsaSize;
@protected
    RSA *_rsa;
}

@property (nonatomic, assign) int padding;

- (instancetype)initWithRSA:(RSA *)rsa;

- (RSA *)rsa;
- (int)RSASize;

- (dispatch_queue_t)concurrentQueue;

- (void)packageData:(NSData *)originalData packageSize:(int)blockSize block:(void(^)(NSUInteger idx, NSData *packageData))block;

// 同步方法
- (NSData *)encrypt:(NSData *)plainData error:(NSError **)error;
- (NSData *)decrypt:(NSData *)cipherData error:(NSError **)error;

// 异步方法
- (void)encrypt:(NSData *)plainData finishedBlock:(void(^)(NSData *cipherData, NSError *error))block;
- (void)decrypt:(NSData *)cipherData finishedBlock:(void(^)(NSData *plainData, NSError *error))block;


+ (NSError *)RSAError;

@end
