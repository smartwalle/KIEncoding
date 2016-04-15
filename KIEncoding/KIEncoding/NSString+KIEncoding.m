//
//  NSString+KIEncoding.m
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSString+KIEncoding.h"

@implementation NSString (KIEncoding)

- (NSData *)dataUsingUTF8Encoding {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)dataUsingHex {
    return [NSData dataWithHex:self];
}


- (NSString *)base64Encoded {
    return [[self dataUsingUTF8Encoding] base64Encoded];
}

- (NSData *)base64Decoded {
    return [[self dataUsingUTF8Encoding] base64Decoded];
}


- (NSString *)URLEncodedString {
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR(":/?#[]@!$&'()*+,;="),
                                                                                             kCFStringEncodingUTF8));
    
    return result;
#else
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
#endif
}

- (NSString *)URLDecodedString {
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_11 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(":/?#[]@!$&'()*+,;="),
                                                                                                             kCFStringEncodingUTF8));
    return result;
#else
    return [self stringByRemovingPercentEncoding];
#endif
}


@end
