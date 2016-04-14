//
//  NSString+KIDigest.m
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSString+KIDigest.h"

@implementation NSString (KIDigest)

- (NSString *)MD5 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data MD5];
    return [rd hexString];
}

- (NSString *)SHA1 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data SHA1];
    return [rd hexString];
}

- (NSString *)SHA224 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data SHA224];
    return [rd hexString];
}

- (NSString *)SHA256 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data SHA256];
    return [rd hexString];
}

- (NSString *)SHA384 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data SHA384];
    return [rd hexString];
}

- (NSString *)SHA512 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data SHA512];
    return [rd hexString];
}

@end
