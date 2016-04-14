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

@end
