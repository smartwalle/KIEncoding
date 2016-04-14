//
//  NSString+KIAES.h
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+KIEncoding.h"
#import "NSData+KIAES.h"

@interface NSString (KIAES)

- (NSData *)AESEncryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits key:(NSString *)key iv:(NSString *)iv;
- (NSData *)AESDecryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits key:(NSString *)key iv:(NSString *)iv;

@end
