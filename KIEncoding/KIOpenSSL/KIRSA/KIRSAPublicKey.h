//
//  KIRSAPublicKey.h
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIRSAKey.h"

@interface KIRSAPublicKey : KIRSAKey

+ (KIRSAPublicKey *)keyWithFile:(NSString *)file;
+ (KIRSAPublicKey *)keyWithData:(NSData *)data;

- (BOOL)writeKeyToFile:(NSString *)file;

- (BOOL)verifySignatureWithSHA128:(NSData *)signature plainData:(NSData *)plainData error:(NSError **)error;
- (BOOL)verifySignatureWithSHA256:(NSData *)cipherData plainData:(NSData *)plainData error:(NSError **)error;
- (BOOL)verifySignatureWithMD5:(NSData *)signature plainData:(NSData *)plainData error:(NSError **)error;

@end
