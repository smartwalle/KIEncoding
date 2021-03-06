//
//  NSData+KIPKCS5.h
//  KIEncoding
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/evp.h>

@interface NSData (KIPKCS5)

- (NSData *)PBKDF2WithSalt:(NSData *)salt keyLen:(int)keyLen;
- (NSData *)PBKDF2WithSalt:(NSData *)salt iter:(int)iter digest:(const EVP_MD *)digest keyLen:(int)keyLen;

@end
