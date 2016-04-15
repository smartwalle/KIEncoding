//
//  KIRSAPrivateKey.h
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIRSAKey.h"

@interface KIRSAPrivateKey : KIRSAKey

- (instancetype)initWithFile:(NSString *)file password:(NSString *)password;
- (instancetype)initWithData:(NSData *)data;

- (BOOL)writeKeyToFile:(NSString *)file;
- (BOOL)writeKeyToFile:(NSString *)file password:(NSString *)password;
- (BOOL)writeKeyToFile:(NSString *)file cipher:(const EVP_CIPHER *)enc password:(NSString *)password;

@end
