//
//  KIRSAKey.m
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "KIRSAKey.h"

@interface KIRSAKey ()
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@end

@implementation KIRSAKey

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
    return err;
}

- (void)dealloc {
    _concurrentQueue = nil;
    
    if (_rsa) {
        RSA_free(_rsa);
    }
}

- (instancetype)initWithRSA:(RSA *)rsa {
    if (self = [super init]) {
        CRYPTO_add(&rsa->references, 1, CRYPTO_LOCK_RSA);
        _rsa = rsa;
    }
    return self;
}

- (void)packageData:(NSData *)originalData packageSize:(int)blockSize block:(void(^)(NSUInteger idx, NSData *packageData))block {
    NSUInteger len = [originalData length];
    
    int diff = len % blockSize;
    NSUInteger count = len / blockSize + (diff > 0 ? 1 : 0);
    
    int blockLen = blockSize;
    
    for (NSUInteger i=0; i<count; i++) {
        if (i == count - 1 && diff > 0) {
            blockLen = diff;
        }
        NSData *pd = [originalData subdataWithRange:NSMakeRange(i*blockSize, blockLen)];
        if (block != nil) {
            block(i, pd);
        }
    }
}

- (NSData *)encrypt:(NSData *)plainData error:(NSError **)error {
    if (plainData == nil) {
        return nil;
    }
    int blockSize = self.RSASize - 11;
    __block NSMutableData *cipherData = [[NSMutableData alloc] init];
    [self packageData:plainData packageSize:blockSize block:^(NSUInteger idx, NSData *packageData) {
        NSData *cd = [self _encrypt:packageData error:error];
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

- (NSData *)_encrypt:(NSData *)plainData error:(NSError **)error {
    return nil;
}

- (NSData *)_decrypt:(NSData *)cipherData error:(NSError **)error {
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

- (dispatch_queue_t)concurrentQueue {
    if (_concurrentQueue == NULL) {
        _concurrentQueue = dispatch_queue_create("KIRSA_QUEUE", DISPATCH_QUEUE_CONCURRENT);
    }
    return _concurrentQueue;
}

@end
