//
//  NSString+KIAES.m
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSString+KIAES.h"

@implementation NSString (KIAES)

- (NSData *)AESEncryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits key:(NSData *)key iv:(NSData *)iv {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data AESEncryptWithMode:mode bits:bits key:key iv:iv];
}

- (NSData *)AESDecryptWithMode:(KIAESMode)mode bits:(KIAESBits)bits key:(NSData *)key iv:(NSData *)iv {
    NSData *data = [NSData dataWithHex:self];
    return [data AESDecryptWithMode:mode bits:bits key:key iv:iv];
}

@end
