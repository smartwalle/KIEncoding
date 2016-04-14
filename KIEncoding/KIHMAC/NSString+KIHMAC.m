//
//  NSString+KIHMAC.m
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSString+KIHMAC.h"

@implementation NSString (KIHMAC)

- (NSString *)hmacMD5:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data hmacMD5:key];
    return [rd hexString];
}

- (NSString *)hmacSHA1:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data hmacSHA1:key];
    return [rd hexString];
}

- (NSString *)hmacSHA224:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data hmacSHA224:key];
    return [rd hexString];
}

- (NSString *)hmacSHA256:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data hmacSHA256:key];
    return [rd hexString];
}

- (NSString *)hmacSHA384:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data hmacSHA384:key];
    return [rd hexString];
}

- (NSString *)hmacSHA512:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *rd = [data hmacSHA512:key];
    return [rd hexString];
}

@end
