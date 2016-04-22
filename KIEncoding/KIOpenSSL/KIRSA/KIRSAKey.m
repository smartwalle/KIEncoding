//
//  KIRSAKey.m
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "KIRSAKey.h"
#import <openssl/sha.h>

@interface KIRSAKey ()
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@end

@implementation KIRSAKey

- (void)dealloc {
    _concurrentQueue = nil;
    
    if (_rsa) {
        RSA_free(_rsa);
    }
}

- (instancetype)init {
    NSAssert(NO, @"调用 initWithRSA 进行初始化");
    return nil;
}

- (instancetype)initWithRSA:(RSA *)rsa {
    NSAssert(![self isMemberOfClass:[KIRSAKey class]], @"不能直接初始化 KIRSAKey");
    if (self = [super init]) {
        CRYPTO_add(&rsa->references, 1, CRYPTO_LOCK_RSA);
        _rsa = rsa;
    }
    return self;
}

- (void)packageData:(NSData *)originalData packageSize:(int)packageSize block:(void(^)(NSUInteger idx, NSData *packageData))block {
    NSUInteger len = [originalData length];
    
    int diff = len % packageSize;
    NSUInteger count = len / packageSize + (diff > 0 ? 1 : 0);
    
    int blockLen = packageSize;
    
    for (NSUInteger i=0; i<count; i++) {
        if (i == count - 1 && diff > 0) {
            blockLen = diff;
        }
        NSData *pd = [originalData subdataWithRange:NSMakeRange(i*packageSize, blockLen)];
        if (block != nil) {
            block(i, pd);
        }
    }
}

- (NSData *)encrypt:(NSData *)plainData error:(NSError **)error {
    if (plainData == nil) {
        return nil;
    }
    __block NSMutableData *cipherData = [[NSMutableData alloc] init];
    [self packageData:plainData packageSize:self.blockSize block:^(NSUInteger idx, NSData *packageData) {
        NSData *cd = [self _encrypt:packageData blockSize:(int)packageData.length error:error];
        if (cd != nil) {
            [cipherData appendData:cd];
        } else {
            cipherData = nil;
            return ;
        }
    }];
    return cipherData;
}

- (NSData *)decrypt:(NSData *)cipherData error:(NSError **)error {
    if (cipherData == nil) {
        return nil;
    }
    __block NSMutableData *plainData = [[NSMutableData alloc] init];
    [self packageData:cipherData packageSize:self.RSASize block:^(NSUInteger idx, NSData *packageData) {
        NSData *pd = [self _decrypt:packageData error:error];
        if (pd != nil) {
            [plainData appendData:pd];
        } else {
            plainData = nil;
            return ;
        }
    }];
    return plainData;
}

- (NSData *)_encrypt:(NSData *)plainData blockSize:(int)blockSize error:(NSError **)error {
    NSAssert(NO, @"KIRSAKEY _encrypt:error 需要由子类实现.");
    return nil;
}

- (NSData *)_decrypt:(NSData *)cipherData error:(NSError **)error {
    NSAssert(NO, @"KIRSAKEY _decrypt:error 需要由子类实现.");
    return nil;
}

- (void)encrypt:(NSData *)plainData finishedBlock:(void(^)(NSData *cipherData, NSError *error))block {
    __weak KIRSAKey *weakSelf = self;
    dispatch_async(self.concurrentQueue, ^{
        KIRSAKey *strongSelf = weakSelf;
        if (strongSelf == nil) {
            return ;
        }
        NSError *error;
        NSData *data = [strongSelf encrypt:plainData error:&error];
        if (block != nil) {
            block(data, error);
        }
    });
}

- (void)decrypt:(NSData *)cipherData finishedBlock:(void(^)(NSData *plainData, NSError *error))block {
    __weak KIRSAKey *weakSelf = self;
    dispatch_async(self.concurrentQueue, ^{
        KIRSAKey *strongSelf = weakSelf;
        if (strongSelf == nil) {
            return ;
        }
        NSError *error;
        NSData *data = [strongSelf decrypt:cipherData error:&error];
        if (block != nil) {
            block(data, error);
        }
    });
}
                       
#pragma mark - Getters & Setters
- (RSA *)rsa {
    return _rsa;
}

- (int)RSASize {
    if (_rsaSize == 0) {
        _rsaSize = RSA_size(_rsa);
    }
    return _rsaSize;
}

- (int)padding {
    if (_padding == 0) {
        _padding = RSA_PKCS1_PADDING;
    }
    return _padding;
}

- (int)blockSize {
    if (self.padding == RSA_PKCS1_PADDING) {
        return self.RSASize - 11;
    } else if (self.padding == RSA_PKCS1_OAEP_PADDING) {
        // http://marc.info/?l=openssl-dev&m=95555102912196&w=2
        // https://www.mail-archive.com/search?l=openssl-dev@openssl.org&q=subject:%22flen+for+RSA_PKCS1_OAEP_PADDING%22&o=newest&f=1
        return self.RSASize - 2 * SHA_DIGEST_LENGTH - 2; // 网上说的是减去41，但是这里设置为41的时候，提示 too large
    } else if (self.padding == RSA_X931_PADDING) {
        return self.RSASize - 2;
    }
    return self.RSASize;
}

- (dispatch_queue_t)concurrentQueue {
    if (_concurrentQueue == NULL) {
        _concurrentQueue = dispatch_queue_create("KIRSA_QUEUE", DISPATCH_QUEUE_CONCURRENT);
    }
    return _concurrentQueue;
}

- (NSData *)keyData {
    NSAssert(NO, @"KIRSAKEY keyData 需要由子类实现.");
    return nil;
}

@end


@implementation KIRSAKey (Error)

+ (NSError *)RSAError {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ERR_load_crypto_strings();
    });
    
    unsigned long errCode = ERR_get_error();
    
    char *errMsg = malloc(130);
    ERR_error_string(errCode, errMsg);
    NSString *errDes = [NSString stringWithFormat:@"KIRSA Error: Code=%lu, Des:%s", errCode, errMsg];
    free(errMsg);
    
    NSError *err = [NSError errorWithDomain:@"KIEncoding" code:errCode userInfo:@{NSLocalizedDescriptionKey: errDes}];
    ERR_free_strings();
    return err;
}

@end