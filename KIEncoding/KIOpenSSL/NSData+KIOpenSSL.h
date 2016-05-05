//
//  NSData+KIOpenSSL.h
//  KIEncoding
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (KIOpenSSL)

+ (NSData *)RANDBytes:(int)len;

@end
